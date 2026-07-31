import mongoose from 'mongoose';
import request from 'supertest';
import {
  afterAll,
  afterEach,
  beforeAll,
  describe,
  expect,
  it,
  vi,
} from 'vitest';

import { createApp } from '../src/app';
import { parseIngredientsText } from '../src/modules/products/barcode.service';

const TEST_URI = 'mongodb://127.0.0.1:27017/healthify_barcode_test';

let dbAvailable = false;
let token = '';
const app = createApp();

/** Stubs global fetch with a per-URL responder. */
function stubWebApi(
  handler: (url: string) => { status: number; body?: unknown } | 'throw',
) {
  vi.stubGlobal('fetch', async (input: RequestInfo | URL) => {
    const url = String(input);
    const result = handler(url);
    if (result === 'throw') throw new Error('ECONNREFUSED');
    return new Response(
      result.body === undefined ? null : JSON.stringify(result.body),
      {
        status: result.status,
        headers: { 'content-type': 'application/json' },
      },
    );
  });
}

const catalogProduct = {
  success: true,
  message: 'OK',
  data: {
    product: {
      id: 'web-id-001',
      slug: 'la-roche-posay-hydrating-cleanser',
      name: 'Hydrating Cleanser',
      barcode: '3337875597180',
      description: 'A gentle cleanser for dry skin.',
      imageUrl: 'https://cdn.example/img.png',
      safetyScore: 88,
      safetyBand: 'excellent',
      suitableSkinTypes: ['dry', 'sensitive'],
      brand: { name: 'La Roche-Posay' },
      category: { name: 'Cleanser' },
      // Deliberately out of order to prove INCI position is respected.
      ingredients: [
        {
          ingredient: {
            inciName: 'Glycerin',
            benefits: ['Hydrating'],
            sideEffects: [],
          },
          position: 1,
        },
        {
          ingredient: {
            inciName: 'Aqua',
            benefits: ['Hydrating'], // Duplicate on purpose — proves dedup.
            sideEffects: [],
          },
          position: 0,
        },
        {
          ingredient: {
            inciName: 'Niacinamide',
            benefits: ['Brightening'],
            sideEffects: ['Occasional flushing'],
          },
          position: 2,
        },
      ],
    },
  },
};

beforeAll(async () => {
  try {
    await mongoose.connect(TEST_URI, { serverSelectionTimeoutMS: 3000 });
    await mongoose.connection.dropDatabase();
    dbAvailable = true;
    const res = await request(app).post('/api/v1/auth/register').send({
      name: 'Barcode Tester',
      email: 'barcode@test.dev',
      password: 'Skincare2026',
    });
    token = res.body.data.tokens.accessToken;
  } catch {
    dbAvailable = false;
  }
});

afterEach(() => {
  vi.unstubAllGlobals();
});

afterAll(async () => {
  if (dbAvailable) {
    await mongoose.connection.dropDatabase();
    await mongoose.disconnect();
  }
});

const get = (code: string) =>
  request(app)
    .get(`/api/v1/products/barcode/${code}`)
    .set('Authorization', `Bearer ${token}`);

describe('barcode lookup', () => {
  it('maps a catalogue hit and preserves INCI order', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    stubWebApi(() => ({ status: 200, body: catalogProduct }));

    const res = await get('3337875597180');

    expect(res.status).toBe(200);
    expect(res.body.data).toMatchObject({
      barcode: '3337875597180',
      name: 'Hydrating Cleanser',
      brand: 'La Roche-Posay',
      category: 'Cleanser',
      source: 'catalog',
      safetyScore: 88,
    });
    expect(res.body.data.ingredientNames).toEqual([
      'Aqua',
      'Glycerin',
      'Niacinamide',
    ]);
  });

  it('carries the full detail — the same fields /products/:slug returns —'
    + ' not just name and ingredients', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    stubWebApi(() => ({ status: 200, body: catalogProduct }));

    const res = await get('3337875597180');

    expect(res.body.data).toMatchObject({
      id: 'web-id-001',
      slug: 'la-roche-posay-hydrating-cleanser',
      description: 'A gentle cleanser for dry skin.',
      safetyBand: 'excellent',
      suitableSkinTypes: ['dry', 'sensitive'],
    });
    // Benefits/side effects are the union of every ingredient's own list,
    // deduplicated — "Hydrating" appears on two ingredients above.
    expect(res.body.data.benefits.sort()).toEqual(
      ['Brightening', 'Hydrating'].sort(),
    );
    expect(res.body.data.sideEffects).toEqual(['Occasional flushing']);
  });

  it('falls back to the external lookup when the catalogue misses',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi((url) =>
        url.endsWith('/external')
          ? {
              status: 200,
              body: {
                success: true,
                message: 'OK',
                data: {
                  external: {
                    name: 'Some Imported Serum',
                    brand: 'Generic',
                    ingredientsText: 'Aqua, Glycerin, Parfum.',
                  },
                },
              },
            }
          : { status: 404, body: { success: false, message: 'Not found' } },
      );

      const res = await get('0123456789012');

      expect(res.status).toBe(200);
      expect(res.body.data.source).toBe('external');
      expect(res.body.data.name).toBe('Some Imported Serum');
      expect(res.body.data.ingredientNames).toEqual([
        'Aqua',
        'Glycerin',
        'Parfum',
      ]);
    });

  it('404s with an OCR hint when neither source knows the code',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi(() => ({ status: 404, body: { success: false } }));

      const res = await get('9999999999999');

      expect(res.status).toBe(404);
      expect(res.body.message).toContain('ingredient list');
    });

  it('degrades to "not found" when the web API is unreachable',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi(() => 'throw');

      const res = await get('3337875597180');

      // A dead upstream must not surface as a 500 — the client's OCR
      // fallback is the right outcome either way.
      expect(res.status).toBe(404);
    });

  it('does not treat a 5xx from the web API as a product', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    stubWebApi(() => ({ status: 502, body: { success: false } }));

    const res = await get('3337875597180');
    expect(res.status).toBe(404);
  });

  it('rejects a malformed barcode before calling the web API', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    const fetchSpy = vi.fn();
    vi.stubGlobal('fetch', fetchSpy);

    // Too short, must start alphanumeric, and capped at 32 characters.
    const tooShort = await get('ab');
    const badLeadingChar = await get('-abc123');
    const tooLong = await get('a'.repeat(33));

    expect(tooShort.status).toBe(422);
    expect(badLeadingChar.status).toBe(422);
    expect(tooLong.status).toBe(422);
    expect(fetchSpy).not.toHaveBeenCalled();
  });

  it('accepts alphanumeric CODE_128-style codes, matching the web validator',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      // Digits-only validation used to 422 these, so a code the web app looks
      // up fine was unusable from mobile.
      stubWebApi(() => ({ status: 404, body: { success: false } }));

      const res = await get('HF-2026_A1');

      expect(res.status).toBe(404); // reached lookup, simply not in catalogue
      expect(res.body.message).toContain('ingredient list');
    });

  it('requires authentication', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    const res = await request(app).get('/api/v1/products/barcode/3337875597180');
    expect(res.status).toBe(401);
  });
});

describe('product catalogue list', () => {
  it('includes a slug on every item, so the client can fetch full detail',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi((url) =>
        url.includes('/products/filters')
          ? { status: 200, body: { success: true, data: { categories: [] } } }
          : {
              status: 200,
              body: {
                success: true,
                data: {
                  items: [
                    {
                      id: 'web-id-002',
                      slug: 'cetaphil-gentle-skin-cleanser',
                      name: 'Gentle Skin Cleanser',
                      brand: { name: 'Cetaphil' },
                      category: { name: 'Cleanser' },
                    },
                  ],
                  total: 1,
                },
              },
            },
      );

      const res = await request(app)
        .get('/api/v1/products?search=cetaphil')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.items[0]).toMatchObject({
        id: 'web-id-002',
        slug: 'cetaphil-gentle-skin-cleanser',
        name: 'Gentle Skin Cleanser',
      });
      // The root bug: a list item was never given ingredients — the client
      // is expected to fetch them via the slug through GET /products/:slug.
      expect(res.body.data.items[0].ingredientNames).toBeUndefined();
    });
});

describe('product detail by slug', () => {
  it('returns the full record a search/catalogue result can only summarise',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi(() => ({
        status: 200,
        body: {
          success: true,
          data: { product: catalogProduct.data.product },
        },
      }));

      const res = await request(app)
        .get('/api/v1/products/la-roche-posay-hydrating-cleanser')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(200);
      expect(res.body.data.ingredientNames).toEqual([
        'Aqua',
        'Glycerin',
        'Niacinamide',
      ]);
      expect(res.body.data.description).toBe('A gentle cleanser for dry skin.');
      expect(res.body.data.safetyScore).toBe(88);
    });

  it('404s rather than 500s when the web API has no such product',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();
      stubWebApi(() => ({ status: 404, body: { success: false } }));

      const res = await request(app)
        .get('/api/v1/products/does-not-exist')
        .set('Authorization', `Bearer ${token}`);

      expect(res.status).toBe(404);
    });

  it('requires authentication', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    const res = await request(app).get(
      '/api/v1/products/la-roche-posay-hydrating-cleanser',
    );
    expect(res.status).toBe(401);
  });

  it('does not shadow /products/barcode/:code', async (ctx) => {
    if (!dbAvailable) return ctx.skip();
    // A request for the barcode endpoint must reach getByBarcode's handler,
    // not be swallowed by the single-segment /:slug route registered after it.
    stubWebApi((url) =>
      url.includes('/barcode/')
        ? { status: 200, body: catalogProduct }
        : { status: 404, body: { success: false } },
    );

    const res = await get('3337875597180');

    expect(res.status).toBe(200);
    expect(res.body.data.source).toBe('catalog');
  });
});

describe('parseIngredientsText', () => {
  it('strips an "Ingredients:" prefix and splits on separators', () => {
    expect(parseIngredientsText('Ingredients: Aqua, Glycerin; Parfum.')).toEqual(
      ['Aqua', 'Glycerin', 'Parfum'],
    );
  });

  it('drops noise tokens', () => {
    expect(parseIngredientsText('Aqua, 5, **, Glycerin')).toEqual([
      'Aqua',
      'Glycerin',
    ]);
  });

  it('returns nothing for empty text', () => {
    expect(parseIngredientsText('')).toEqual([]);
  });
});
