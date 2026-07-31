import mongoose from 'mongoose';
import request from 'supertest';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { createApp } from '../src/app';

/**
 * End-to-end API tests against a real MongoDB (uses the local instance,
 * isolated in the healthify_test database). Skipped automatically when
 * MongoDB is not reachable so the unit suite still runs anywhere.
 */
const TEST_URI = 'mongodb://127.0.0.1:27017/healthify_test';

let dbAvailable = false;
const app = createApp();

beforeAll(async () => {
  try {
    await mongoose.connect(TEST_URI, { serverSelectionTimeoutMS: 3000 });
    await mongoose.connection.dropDatabase();
    dbAvailable = true;
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

const account = {
  name: 'Sarah Johnson',
  email: 'sarah@test.dev',
  password: 'Skincare2026',
};

describe('auth + profile flow', () => {
  it('registers, logs in, refreshes, and manages the skin profile', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    // Register
    const registerRes = await request(app)
      .post('/api/v1/auth/register')
      .send(account);
    expect(registerRes.status).toBe(201);
    expect(registerRes.body.data.user.email).toBe(account.email);
    expect(registerRes.body.data.user.passwordHash).toBeUndefined();
    const { accessToken, refreshToken } = registerRes.body.data.tokens;

    // Duplicate register → 409
    const dupRes = await request(app)
      .post('/api/v1/auth/register')
      .send(account);
    expect(dupRes.status).toBe(409);

    // Wrong password → 401
    const badLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: account.email, password: 'WrongPass1' });
    expect(badLogin.status).toBe(401);

    // /users/me with token
    const meRes = await request(app)
      .get('/api/v1/users/me')
      .set('Authorization', `Bearer ${accessToken}`);
    expect(meRes.status).toBe(200);
    expect(meRes.body.data.name).toBe(account.name);

    // Save skin profile
    const profileRes = await request(app)
      .put('/api/v1/users/me/skin-profile')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({
        age: 24,
        gender: 'female',
        skinType: 'oily',
        concerns: ['acne', 'pores'],
        allergies: ['Fragrance'],
        goals: ['Clearer skin'],
      });
    expect(profileRes.status).toBe(200);
    expect(profileRes.body.data.skinProfile.skinType).toBe('oily');

    // Invalid skin type → 422 with field errors
    const badProfile = await request(app)
      .put('/api/v1/users/me/skin-profile')
      .set('Authorization', `Bearer ${accessToken}`)
      .send({ skinType: 'glittery' });
    expect(badProfile.status).toBe(422);
    expect(badProfile.body.errors).toBeDefined();

    // Refresh rotates the token
    const refreshRes = await request(app)
      .post('/api/v1/auth/refresh')
      .send({ refreshToken });
    expect(refreshRes.status).toBe(200);
    const newRefresh = refreshRes.body.data.tokens.refreshToken;
    expect(newRefresh).not.toBe(refreshToken);

    // Replaying the old refresh token is rejected
    const replayRes = await request(app)
      .post('/api/v1/auth/refresh')
      .send({ refreshToken });
    expect(replayRes.status).toBe(401);

    // Dashboard aggregates (seeded ingredients arrive via connectDatabase
    // in production; here the collection may be empty — shape still holds)
    const dashRes = await request(app)
      .get('/api/v1/dashboard')
      .set('Authorization', `Bearer ${accessToken}`);
    expect(dashRes.status).toBe(200);
    expect(dashRes.body.data.todayInsight.title).toBeTypeOf('string');
    expect(dashRes.body.data.weeklyStats.scans).toBe(0);

    // Unauthenticated dashboard → 401
    const anonRes = await request(app).get('/api/v1/dashboard');
    expect(anonRes.status).toBe(401);
  });

  it('completes the forgot/reset password loop with the dev code', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const forgotRes = await request(app)
      .post('/api/v1/auth/forgot-password')
      .send({ email: account.email });
    expect(forgotRes.status).toBe(200);
    const devCode = forgotRes.body.data?.devCode as string;
    expect(devCode).toHaveLength(6);

    const resetRes = await request(app)
      .post('/api/v1/auth/reset-password')
      .send({ email: account.email, code: devCode, password: 'NewPass2026' });
    expect(resetRes.status).toBe(200);

    const oldLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: account.email, password: account.password });
    expect(oldLogin.status).toBe(401);

    const newLogin = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: account.email, password: 'NewPass2026' });
    expect(newLogin.status).toBe(200);
  });

  it('rejects Google sign-in with a clear error when GOOGLE_CLIENT_ID is unset', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    // The test env never sets GOOGLE_CLIENT_ID, matching a dev machine that
    // hasn't configured Google Sign-In — the endpoint must fail loudly
    // rather than silently accepting an unverifiable token.
    const res = await request(app)
      .post('/api/v1/auth/google')
      .send({ idToken: 'not-a-real-token' });
    expect(res.status).toBe(500);
    expect(res.body.message).toMatch(/not configured/i);
  });

  it('rejects a Google sign-in request with a missing idToken', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app).post('/api/v1/auth/google').send({});
    expect(res.status).toBe(422);
  });
});
