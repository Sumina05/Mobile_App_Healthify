import mongoose from 'mongoose';
import request from 'supertest';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { createApp } from '../src/app';
import { analysisService } from '../src/modules/analysis/analysis.service';
import { ingredientService } from '../src/modules/ingredients/ingredient.service';

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
      name: 'Scan Tester',
      email: 'scanner@test.dev',
      password: 'Skincare2026',
    });
    token = registerRes.body.data.tokens.accessToken;

    await request(app)
      .put('/api/v1/users/me/skin-profile')
      .set('Authorization', `Bearer ${token}`)
      .send({
        skinType: 'sensitive',
        concerns: ['acne', 'redness'],
        allergies: ['Fragrance'],
        goals: ['Calmer, less red skin'],
      });
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

describe('analysis pipeline', () => {
  let firstId = '';
  let secondId = '';

  it('analyzes a scanned list: matching, allergy, irritation, AI text, alternatives', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app)
      .post('/api/v1/analysis')
      .set('Authorization', `Bearer ${token}`)
      .send({
        productName: 'Harsh Cleanser X',
        brand: 'TestBrand',
        rawText: 'Ingredients: Niacinamide, Fragrance, Alcohol Denat., Unicornium',
        ingredients: [
          'Niacinamide',
          'Fragrance',
          'Alcohol Denat.',
          'Unicornium',
        ],
      });

    expect(res.status).toBe(201);
    const analysis = res.body.data;
    firstId = analysis.id;

    // Matching: 3 of 4 known
    expect(analysis.matchedCount).toBe(3);
    const statuses = Object.fromEntries(
      analysis.breakdown.map((b: { name: string; status: string }) => [
        b.name,
        b.status,
      ]),
    );
    expect(statuses['Niacinamide']).toBe('good');
    expect(statuses['Fragrance']).toBe('allergy'); // declared allergy
    expect(statuses['Unicornium']).toBe('neutral'); // unknown
    // Alcohol Denat. cautions for sensitive skin → irritation warning
    expect(
      analysis.warnings.some((w: string) => w.includes('sensitive')),
    ).toBe(true);
    expect(
      analysis.warnings.some((w: string) => w.includes('allergy')),
    ).toBe(true);

    expect(analysis.safetyRating).toBe('high_risk');
    expect(analysis.score).toBeLessThan(70);
    expect(analysis.aiExplanation.length).toBeGreaterThan(20);
    expect(analysis.recommendationReason.length).toBeGreaterThan(20);
    // Alternatives: catalog products scoring higher for this profile
    expect(analysis.alternatives.length).toBeGreaterThan(0);
    expect(analysis.alternatives[0].matchPercent).toBeGreaterThan(
      analysis.score,
    );
  });

  it('saves to history and updates dashboard stats automatically', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const gentle = await request(app)
      .post('/api/v1/analysis')
      .set('Authorization', `Bearer ${token}`)
      .send({
        productName: 'Gentle Barrier Cream',
        ingredients: ['Niacinamide', 'Ceramide NP', 'Panthenol', 'Squalane'],
      });
    secondId = gentle.body.data.id;
    expect(gentle.body.data.score).toBeGreaterThan(70);

    const history = await request(app)
      .get('/api/v1/analysis/history')
      .set('Authorization', `Bearer ${token}`);
    expect(history.body.data.items).toHaveLength(2);

    const dash = await request(app)
      .get('/api/v1/dashboard')
      .set('Authorization', `Bearer ${token}`);
    expect(dash.body.data.weeklyStats.scans).toBe(2);
    expect(dash.body.data.skinScore).toBe(gentle.body.data.score);
    expect(dash.body.data.recentAnalyses).toHaveLength(2);
  });

  it('compares two analyses and picks the winner', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app)
      .post('/api/v1/analysis/compare')
      .set('Authorization', `Bearer ${token}`)
      .send({ analysisIdA: firstId, analysisIdB: secondId });

    expect(res.status).toBe(200);
    expect(res.body.data.winner).toBe(secondId);
    expect(res.body.data.deltas.score).toBeLessThan(0);

    const same = await request(app)
      .post('/api/v1/analysis/compare')
      .set('Authorization', `Bearer ${token}`)
      .send({ analysisIdA: firstId, analysisIdB: firstId });
    expect(same.status).toBe(400);
  });

  it('toggles the favorite bookmark', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const on = await request(app)
      .patch(`/api/v1/analysis/${secondId}/favorite`)
      .set('Authorization', `Bearer ${token}`);
    expect(on.body.data.favorite).toBe(true);

    const off = await request(app)
      .patch(`/api/v1/analysis/${secondId}/favorite`)
      .set('Authorization', `Bearer ${token}`);
    expect(off.body.data.favorite).toBe(false);
  });

  it('answers contextual questions about an analysis via /chat', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const res = await request(app)
      .post('/api/v1/chat')
      .set('Authorization', `Bearer ${token}`)
      .send({
        message: 'Why did this product score low?',
        analysisId: firstId,
      });

    expect(res.status).toBe(200);
    expect(res.body.data.reply).toContain('Harsh Cleanser X');

    const plain = await request(app)
      .post('/api/v1/chat')
      .set('Authorization', `Bearer ${token}`)
      .send({ message: 'What is niacinamide?' });
    expect(plain.body.data.reply.toLowerCase()).toContain('niacinamide');
  });
});
