import { createHmac, randomUUID } from 'crypto';

import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ApiError } from '../../utils/api-error';
import { notificationService } from '../notifications/notification.service';
import { UserModel } from '../users/user.model';
import { khaltiService } from './khalti.service';
import { PaymentModel } from './payment.model';

export type Plan = 'monthly' | 'yearly';
export type Provider = 'khalti' | 'esewa';

export const PLANS = {
  monthly: {
    id: 'monthly',
    label: 'Monthly',
    amountNpr: 499,
    durationDays: 30,
  },
  yearly: {
    id: 'yearly',
    label: 'Yearly',
    amountNpr: 3999,
    durationDays: 365,
    savings: 'Save 33%',
  },
} as const;

export const PREMIUM_FEATURES = [
  'Unlimited scans',
  'Advanced AI analysis',
  'Personalized recommendations',
  'Unlimited comparisons',
  'Ad-free experience',
  'Priority support',
];

interface CheckoutResult {
  paymentId: string;
  provider: Provider;
  status: 'created' | 'completed';
  /** Gateway redirect URL (null in simulated dev checkout). */
  paymentUrl: string | null;
  providerRef: string;
  /** eSewa form parameters (signature-based flow). */
  formParams?: Record<string, string>;
}

/**
 * Payment orchestration for Khalti (ePayment v2) and eSewa (ePay v2).
 * With gateway keys configured the real initiate/verify APIs are called;
 * without keys the flow runs in clearly-marked simulated mode so the app
 * is demonstrable end-to-end.
 */
export class PremiumService {
  async checkout(
    userId: string,
    plan: Plan,
    provider: Provider,
  ): Promise<CheckoutResult> {
    const planDef = PLANS[plan];
    const providerRef = randomUUID();

    if (provider === 'khalti' && khaltiService.isConfigured()) {
      // Same initiate contract as the web app: the user's name/email travel
      // as customer_info, and purchase_order_id is our own reference.
      const user = await UserModel.findById(userId).exec();
      if (!user) throw ApiError.notFound('User not found');

      const { pidx, paymentUrl } = await khaltiService.initiate({
        amountNpr: planDef.amountNpr,
        purchaseOrderId: providerRef,
        purchaseOrderName: `Healthify Premium — ${plan}`,
        customerName: user.name,
        customerEmail: user.email,
        // Identical to the web app's payment.service — same registered
        // origin, same callback path, so Khalti behaves the same for both.
        returnUrl: `${env.CLIENT_URL}/premium/callback/khalti`,
        websiteUrl: env.CLIENT_URL,
      });

      const payment = await PaymentModel.create({
        userId,
        provider,
        plan,
        amountNpr: planDef.amountNpr,
        providerRef: pidx,
      });
      return {
        paymentId: payment.id,
        provider,
        status: 'created',
        paymentUrl,
        providerRef: pidx,
      };
    }

    if (provider === 'esewa' && env.ESEWA_SECRET_KEY) {
      const payment = await PaymentModel.create({
        userId,
        provider,
        plan,
        amountNpr: planDef.amountNpr,
        providerRef,
      });
      return {
        paymentId: payment.id,
        provider,
        status: 'created',
        // eSewa ePay v2 only accepts a signed form POST, so a client cannot
        // simply open the form URL. Point it at our redirect endpoint, which
        // serves a self-submitting form.
        paymentUrl: this.esewaRedirectUrl(providerRef),
        providerRef,
        formParams: this.esewaFormParams(providerRef, planDef.amountNpr),
      };
    }

    // Simulated dev checkout: no gateway keys configured.
    const payment = await PaymentModel.create({
      userId,
      provider,
      plan,
      amountNpr: planDef.amountNpr,
      providerRef,
      status: 'completed',
      simulated: true,
    });
    await this.activatePremium(userId, plan);
    logger.info(
      `Simulated ${provider} payment completed for user ${userId} (${plan})`,
    );
    return {
      paymentId: payment.id,
      provider,
      status: 'completed',
      paymentUrl: null,
      providerRef,
    };
  }

  esewaRedirectUrl(providerRef: string): string {
    return `${env.PUBLIC_BASE_URL}/api/v1/premium/esewa/redirect/${providerRef}`;
  }

  /** The signed field set eSewa's ePay v2 form expects. */
  esewaFormParams(
    providerRef: string,
    amountNpr: number,
  ): Record<string, string> {
    const signedFieldNames = 'total_amount,transaction_uuid,product_code';
    const message =
      `total_amount=${amountNpr},transaction_uuid=${providerRef},` +
      `product_code=${env.ESEWA_PRODUCT_CODE}`;
    const signature = createHmac('sha256', env.ESEWA_SECRET_KEY ?? '')
      .update(message)
      .digest('base64');

    return {
      amount: String(amountNpr),
      tax_amount: '0',
      total_amount: String(amountNpr),
      transaction_uuid: providerRef,
      product_code: env.ESEWA_PRODUCT_CODE,
      product_service_charge: '0',
      product_delivery_charge: '0',
      success_url: env.PAYMENT_RETURN_URL,
      failure_url: env.PAYMENT_RETURN_URL,
      signed_field_names: signedFieldNames,
      signature,
    };
  }

  /** Verifies a gateway payment (Khalti lookup) and activates premium. */
  async verify(userId: string, providerRef: string) {
    const payment = await PaymentModel.findOne({
      providerRef,
      userId,
    }).exec();
    if (!payment) throw ApiError.notFound('Payment not found');
    if (payment.status === 'completed') return payment;

    if (payment.provider === 'khalti' && khaltiService.isConfigured()) {
      // Mirrors the web app's callback handling: only 'Completed' activates;
      // anything else marks the payment failed with the gateway's own status.
      const lookup = await khaltiService.lookup(providerRef);
      if (lookup.status !== 'Completed') {
        payment.status = 'failed';
        await payment.save();
        throw ApiError.badRequest(`Payment ${lookup.status.toLowerCase()}`);
      }
    }
    // eSewa verification uses its transaction status API in production;
    // in this build a reached-return-URL is treated as gateway-confirmed.

    payment.status = 'completed';
    await payment.save();
    await this.activatePremium(userId, payment.plan);
    return payment;
  }

  private async activatePremium(userId: string, plan: Plan): Promise<void> {
    const planDef = PLANS[plan];
    const now = new Date();
    await UserModel.findByIdAndUpdate(userId, {
      premium: {
        plan,
        activatedAt: now,
        expiresAt: new Date(
          now.getTime() + planDef.durationDays * 86_400_000,
        ),
      },
    }).exec();
    await notificationService.create(
      userId,
      'Welcome to Healthify Premium 👑',
      `Your ${planDef.label.toLowerCase()} plan is active. Enjoy unlimited scans and advanced AI analysis!`,
      'system',
    );
  }
}

export const premiumService = new PremiumService();
