import { Router } from 'express';
import { z } from 'zod';

import { env } from '../../config/env';
import { requireAuth } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { PaymentModel } from './payment.model';
import {
  PLANS,
  PREMIUM_FEATURES,
  premiumService,
} from './premium.service';

const router = Router();

/** Escapes a value for safe interpolation into an HTML attribute. */
function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

/**
 * @openapi
 * /premium/esewa/redirect/{providerRef}:
 *   get:
 *     summary: Self-submitting eSewa payment form
 *     description: >
 *       eSewa ePay v2 only accepts a signed form POST, which a mobile client
 *       cannot perform by opening a URL. This endpoint returns a tiny HTML
 *       page that posts the signed fields on load. It is intentionally
 *       unauthenticated because the payer's browser carries no JWT; the
 *       signature authorizes a payment *to* Healthify, so it grants nothing
 *       to a third party who guesses a reference.
 *     tags: [Premium]
 *     responses:
 *       200: { description: HTML form that redirects to eSewa }
 *       404: { description: Unknown or already-completed payment }
 */
router.get('/esewa/redirect/:providerRef', async (req, res) => {
  const providerRef = req.params.providerRef as string;
  const payment = await PaymentModel.findOne({
    providerRef,
    provider: 'esewa',
    status: 'created',
  }).exec();
  if (!payment) throw ApiError.notFound('Payment not found');

  const params = premiumService.esewaFormParams(
    providerRef,
    payment.amountNpr,
  );
  const fields = Object.entries(params)
    .map(
      ([name, value]) =>
        `<input type="hidden" name="${escapeHtml(name)}" value="${escapeHtml(value)}">`,
    )
    .join('\n    ');

  res
    .status(200)
    .type('html')
    .send(
      `<!doctype html>
<html lang="en">
<head><meta charset="utf-8"><title>Redirecting to eSewa…</title></head>
<body onload="document.forms[0].submit()">
  <p>Redirecting to eSewa…</p>
  <form method="POST" action="${escapeHtml(env.ESEWA_FORM_URL)}">
    ${fields}
    <noscript><button type="submit">Continue to eSewa</button></noscript>
  </form>
</body>
</html>`,
    );
});

router.use(requireAuth);

const checkoutSchema = z.object({
  plan: z.enum(['monthly', 'yearly']),
  provider: z.enum(['khalti', 'esewa']),
});

const verifySchema = z.object({
  providerRef: z.string().min(1),
});

/**
 * @openapi
 * /premium/plans:
 *   get:
 *     summary: Premium plans, pricing (NPR) and feature list
 *     tags: [Premium]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Plans + features }
 */
router.get('/plans', (_req, res) => {
  sendSuccess(res, {
    plans: Object.values(PLANS),
    features: PREMIUM_FEATURES,
    providers: ['khalti', 'esewa'],
  });
});

/**
 * @openapi
 * /premium/checkout:
 *   post:
 *     summary: Start a Khalti or eSewa payment for a plan
 *     description: >
 *       With gateway keys configured this calls the real initiate API and
 *       returns a payment URL; without keys it completes a clearly-marked
 *       simulated payment so the flow is demonstrable end-to-end.
 *     tags: [Premium]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       201: { description: Payment created (or completed in simulated mode) }
 */
router.post(
  '/checkout',
  validate({ body: checkoutSchema }),
  async (req, res) => {
    const result = await premiumService.checkout(
      req.user!.id,
      req.body.plan,
      req.body.provider,
    );
    sendSuccess(res, result, 'Checkout started', 201);
  },
);

/**
 * @openapi
 * /premium/verify:
 *   post:
 *     summary: Verify a gateway payment and activate premium
 *     tags: [Premium]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Completed payment }
 *       400: { description: Payment not completed at the gateway }
 */
router.post('/verify', validate({ body: verifySchema }), async (req, res) => {
  const payment = await premiumService.verify(
    req.user!.id,
    req.body.providerRef,
  );
  sendSuccess(res, payment, 'Premium activated');
});

/**
 * @openapi
 * /premium/payments:
 *   get:
 *     summary: The user's payment history
 *     tags: [Premium]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Payments, newest first }
 */
router.get('/payments', async (req, res) => {
  const items = await PaymentModel.find({ userId: req.user!.id })
    .sort({ createdAt: -1 })
    .limit(50)
    .exec();
  sendSuccess(res, { items });
});

export default router;
