import mongoose from 'mongoose';
import request from 'supertest';
import { afterAll, beforeAll, describe, expect, it, vi } from 'vitest';

import { khaltiService } from '../src/modules/premium/khalti.service';

import { createApp } from '../src/app';
import { analysisService } from '../src/modules/analysis/analysis.service';
import { ingredientService } from '../src/modules/ingredients/ingredient.service';
import { PaymentModel } from '../src/modules/premium/payment.model';
import { UserModel } from '../src/modules/users/user.model';

const TEST_URI = 'mongodb://127.0.0.1:27017/healthify_test';

let dbAvailable = false;
let token = '';
const app = createApp();

beforeAll(async () => {
  try {
    await mongoose.connect(TEST_URI, { serverSelectionTimeoutMS: 3000 });
    await mongoose.connection.dropDatabase();
    await ingredientService.seedIfEmpty();
    await analysisService.seedProductsIfEmpty();
    dbAvailable = true;

    const registerRes = await request(app).post('/api/v1/auth/register').send({
      name: 'Premium Tester',
      email: 'premium@test.dev',
      password: 'Skincare2026',
    });
    token = registerRes.body.data.tokens.accessToken;
  } catch {
    dbAvailable = false;
  }
});

afterAll(async () => {
  if (dbAvailable) {
    await mongoose.connection.dropDatabase();
    await mongoose.disconnect();
  }
});

describe('premium & payments', () => {
  it('lists plans with NPR pricing and both providers', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app)
      .get('/api/v1/premium/plans')
      .set('Authorization', `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.plans).toHaveLength(2);
    expect(res.body.data.providers).toEqual(['khalti', 'esewa']);
    expect(res.body.data.features.length).toBeGreaterThan(3);
  });

  it('completes a simulated Khalti checkout and activates premium', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    // Pin the gateway as unconfigured so this exercises the simulated path
    // deterministically — otherwise the result depends on whether the machine
    // running the tests happens to have KHALTI_SECRET_KEY in its .env.
    const configured = vi
      .spyOn(khaltiService, 'isConfigured')
      .mockReturnValue(false);

    const res = await request(app)
      .post('/api/v1/premium/checkout')
      .set('Authorization', `Bearer ${token}`)
      .send({ plan: 'yearly', provider: 'khalti' });
    configured.mockRestore();

    expect(res.status).toBe(201);
    expect(res.body.data.status).toBe('completed'); // simulated (no keys)
    expect(res.body.data.paymentUrl).toBeNull();

    const me = await request(app)
      .get('/api/v1/users/me')
      .set('Authorization', `Bearer ${token}`);
    expect(me.body.data.premium.plan).toBe('yearly');
    expect(new Date(me.body.data.premium.expiresAt).getTime()).toBeGreaterThan(
      Date.now() + 300 * 86_400_000,
    );

    const payments = await request(app)
      .get('/api/v1/premium/payments')
      .set('Authorization', `Bearer ${token}`);
    expect(payments.body.data.items[0].amountNpr).toBe(3999);
    expect(payments.body.data.items[0].simulated).toBe(true);
  });
});

describe('Khalti gateway checkout (configured)', () => {
  it('returns the gateway payment URL instead of activating premium',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      const configured = vi
        .spyOn(khaltiService, 'isConfigured')
        .mockReturnValue(true);
      const initiate = vi
        .spyOn(khaltiService, 'initiate')
        .mockResolvedValue({
          pidx: 'test-pidx-001',
          paymentUrl: 'https://test-pay.khalti.com/?pidx=test-pidx-001',
        });

      const res = await request(app)
        .post('/api/v1/premium/checkout')
        .set('Authorization', `Bearer ${token}`)
        .send({ plan: 'monthly', provider: 'khalti' });

      expect(res.status).toBe(201);
      // A real gateway checkout must NOT complete server-side.
      expect(res.body.data.status).toBe('created');
      expect(res.body.data.paymentUrl).toContain('khalti.com');
      expect(res.body.data.providerRef).toBe('test-pidx-001');

      // Same initiate contract as the web backend, including customer_info
      // and the paisa conversion happening inside the adapter.
      expect(initiate).toHaveBeenCalledWith(
        expect.objectContaining({
          amountNpr: 499,
          customerEmail: 'premium@test.dev',
          purchaseOrderName: 'Healthify Premium — monthly',
        }),
      );

      configured.mockRestore();
      initiate.mockRestore();
    });

  it('refuses to activate premium when the lookup is not Completed',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      const configured = vi
        .spyOn(khaltiService, 'isConfigured')
        .mockReturnValue(true);
      vi.spyOn(khaltiService, 'initiate').mockResolvedValue({
        pidx: 'test-pidx-002',
        paymentUrl: 'https://test-pay.khalti.com/?pidx=test-pidx-002',
      });
      const lookup = vi
        .spyOn(khaltiService, 'lookup')
        .mockResolvedValue({ status: 'User canceled', totalAmountNpr: 499 });

      await request(app)
        .post('/api/v1/premium/checkout')
        .set('Authorization', `Bearer ${token}`)
        .send({ plan: 'monthly', provider: 'khalti' });

      const verify = await request(app)
        .post('/api/v1/premium/verify')
        .set('Authorization', `Bearer ${token}`)
        .send({ providerRef: 'test-pidx-002' });

      expect(verify.status).toBe(400);
      expect(verify.body.message).toBe('Payment user canceled');
      expect(lookup).toHaveBeenCalledWith('test-pidx-002');

      vi.restoreAllMocks();
      configured.mockRestore();
    });

  it('activates premium when the lookup reports Completed', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    vi.spyOn(khaltiService, 'isConfigured').mockReturnValue(true);
    vi.spyOn(khaltiService, 'initiate').mockResolvedValue({
      pidx: 'test-pidx-003',
      paymentUrl: 'https://test-pay.khalti.com/?pidx=test-pidx-003',
    });
    vi.spyOn(khaltiService, 'lookup').mockResolvedValue({
      status: 'Completed',
      totalAmountNpr: 499,
    });

    await request(app)
      .post('/api/v1/premium/checkout')
      .set('Authorization', `Bearer ${token}`)
      .send({ plan: 'monthly', provider: 'khalti' });

    const verify = await request(app)
      .post('/api/v1/premium/verify')
      .set('Authorization', `Bearer ${token}`)
      .send({ providerRef: 'test-pidx-003' });

    expect(verify.status).toBe(200);

    const me = await request(app)
      .get('/api/v1/users/me')
      .set('Authorization', `Bearer ${token}`);
    expect(me.body.data.premium).not.toBeNull();

    vi.restoreAllMocks();
  });
});

describe('eSewa redirect', () => {
  it('404s for an unknown payment reference', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app).get(
      '/api/v1/premium/esewa/redirect/does-not-exist',
    );
    expect(res.status).toBe(404);
  });

  it('serves a self-submitting signed form for a pending eSewa payment',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      // Checkout runs in simulated mode without gateway keys, so create the
      // pending eSewa payment directly to exercise the redirect endpoint.
      const user = await UserModel.findOne({ email: 'premium@test.dev' })
        .exec();
      const providerRef = 'test-esewa-ref-0001';
      await PaymentModel.create({
        userId: user!._id,
        provider: 'esewa',
        plan: 'monthly',
        amountNpr: 499,
        providerRef,
      });

      const res = await request(app).get(
        `/api/v1/premium/esewa/redirect/${providerRef}`,
      );

      expect(res.status).toBe(200);
      expect(res.headers['content-type']).toContain('text/html');
      // Posts to eSewa, not to us, and carries the signed field set.
      expect(res.text).toContain('method="POST"');
      expect(res.text).toContain('esewa.com.np');
      expect(res.text).toContain(`value="${providerRef}"`);
      expect(res.text).toContain('name="signature"');
      expect(res.text).toContain('name="total_amount" value="499"');
      expect(res.text).toContain('document.forms[0].submit()');
    });
});

describe('product search', () => {
  it('searches by name/brand/ingredient with pagination meta', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app)
      .get('/api/v1/products?search=niacinamide')
      .set('Authorization', `Bearer ${token}`);

    expect(res.status).toBe(200);
    expect(res.body.data.items.length).toBeGreaterThan(0);
    expect(res.body.meta.total).toBeGreaterThan(0);
    expect(res.body.data.categories).toContain('Moisturizer');

    const filtered = await request(app)
      .get('/api/v1/products?category=Cleanser')
      .set('Authorization', `Bearer ${token}`);
    expect(
      filtered.body.data.items.every(
        (p: { category: string }) => p.category === 'Cleanser',
      ),
    ).toBe(true);
  });
});

describe('admin API', () => {
  it('rejects non-admin users and serves stats to admins', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const denied = await request(app)
      .get('/api/v1/admin/stats')
      .set('Authorization', `Bearer ${token}`);
    expect(denied.status).toBe(403);

    // Promote and get a fresh token carrying the admin role.
    await UserModel.updateOne(
      { email: 'premium@test.dev' },
      { role: 'admin' },
    ).exec();
    const login = await request(app).post('/api/v1/auth/login').send({
      email: 'premium@test.dev',
      password: 'Skincare2026',
    });
    const adminToken = login.body.data.tokens.accessToken;

    const stats = await request(app)
      .get('/api/v1/admin/stats')
      .set('Authorization', `Bearer ${adminToken}`);
    expect(stats.status).toBe(200);
    expect(stats.body.data.users.total).toBeGreaterThan(0);
    expect(stats.body.data.users.premium).toBe(1);
    expect(stats.body.data.catalog.ingredients).toBeGreaterThan(10);
    // At least the yearly plan; other tests in this file may also have
    // completed payments, so don't couple this to an exact total.
    expect(stats.body.data.revenueNpr).toBeGreaterThanOrEqual(3999);

    // Admin ingredient CRUD round-trip
    const created = await request(app)
      .post('/api/v1/admin/ingredients')
      .set('Authorization', `Bearer ${adminToken}`)
      .send({
        name: 'Bakuchiol',
        tagline: 'The gentle retinol alternative',
        purpose: 'A plant-derived retinol alternative.',
        description: 'Smooths skin without retinol irritation.',
        safetyRating: 'safe',
        goodForSkinTypes: ['sensitive'],
        concernsTargeted: ['aging'],
      });
    expect(created.status).toBe(201);

    const removed = await request(app)
      .delete(`/api/v1/admin/ingredients/${created.body.data.id}`)
      .set('Authorization', `Bearer ${adminToken}`);
    expect(removed.status).toBe(200);
  });
});
