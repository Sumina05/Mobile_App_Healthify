import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ApiError } from '../../utils/api-error';

/**
 * Khalti ePayment v2 adapter — ported from the Healthify web backend
 * (`Healthify_Web_Backend/src/services/khalti.service.ts`) so both apps talk
 * to Khalti identically: same endpoints, same paisa conversion, same
 * `customer_info` payload, same lookup status handling.
 *
 * It is a separate copy rather than a proxy because premium activation writes
 * to *this* service's user records; the two backends have separate user
 * databases, so a payment brokered by the web API would activate premium on a
 * web user that has no counterpart here.
 *
 * Every call requires `KHALTI_SECRET_KEY` — callers must check
 * {@link isConfigured} first and fall back to the simulated flow, so Premium
 * still works with zero merchant setup in development.
 */

export interface KhaltiInitiateInput {
  amountNpr: number;
  purchaseOrderId: string;
  purchaseOrderName: string;
  customerName: string;
  customerEmail: string;
  returnUrl: string;
  websiteUrl: string;
}

export interface KhaltiInitiateResult {
  pidx: string;
  paymentUrl: string;
}

export type KhaltiLookupStatus =
  | 'Completed'
  | 'Pending'
  | 'Expired'
  | 'User canceled'
  | 'Refunded'
  | 'Partially Refunded';

export interface KhaltiLookupResult {
  status: KhaltiLookupStatus;
  totalAmountNpr: number;
}

const REQUEST_TIMEOUT_MS = 15_000;

export const khaltiService = {
  isConfigured(): boolean {
    return Boolean(env.KHALTI_SECRET_KEY);
  },

  async initiate(input: KhaltiInitiateInput): Promise<KhaltiInitiateResult> {
    const res = await fetch(`${env.KHALTI_BASE_URL}/epayment/initiate/`, {
      method: 'POST',
      headers: {
        Authorization: `Key ${env.KHALTI_SECRET_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        return_url: input.returnUrl,
        website_url: input.websiteUrl,
        amount: Math.round(input.amountNpr * 100), // Khalti amounts are in paisa
        purchase_order_id: input.purchaseOrderId,
        purchase_order_name: input.purchaseOrderName,
        customer_info: {
          name: input.customerName,
          email: input.customerEmail,
        },
      }),
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
    });

    if (!res.ok) {
      const body = await res.text().catch(() => '');
      logger.error(`Khalti initiate failed: ${res.status} ${body}`);
      throw ApiError.internal(
        'Could not start the Khalti checkout. Please try again.',
      );
    }

    const data = (await res.json()) as { pidx: string; payment_url: string };
    return { pidx: data.pidx, paymentUrl: data.payment_url };
  },

  async lookup(pidx: string): Promise<KhaltiLookupResult> {
    const res = await fetch(`${env.KHALTI_BASE_URL}/epayment/lookup/`, {
      method: 'POST',
      headers: {
        Authorization: `Key ${env.KHALTI_SECRET_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ pidx }),
      signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
    });

    if (!res.ok) {
      const body = await res.text().catch(() => '');
      logger.error(`Khalti lookup failed: ${res.status} ${body}`);
      throw ApiError.internal('Could not verify the Khalti payment.');
    }

    const data = (await res.json()) as {
      status: KhaltiLookupStatus;
      total_amount: number;
    };
    return { status: data.status, totalAmountNpr: data.total_amount / 100 };
  },
};
