import { Router } from 'express';
import { z } from 'zod';

import { requireAuth } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { barcodeService, catalogService } from './barcode.service';

const router = Router();
router.use(requireAuth);

/**
 * Mirrors the web backend's `barcodeCode` validator
 * (`Healthify_Web_Backend/src/validators/product.validators.ts`) rather than
 * digits-only: product labels also carry alphanumeric CODE_128/CODE_39, and
 * rejecting them here would 422 a code the web app looks up happily.
 */
const barcodeParamsSchema = z.object({
  code: z
    .string()
    .trim()
    .regex(
      /^[A-Za-z0-9][A-Za-z0-9._-]{5,31}$/,
      'That does not look like a scannable barcode',
    ),
});

/**
 * @openapi
 * /products/barcode/{code}:
 *   get:
 *     summary: Resolve an EAN/UPC barcode to a product and its ingredients
 *     description: >
 *       Proxies to the Healthify web API, which owns the product catalogue and
 *       its barcode mappings — this service stores no barcode data of its own.
 *       Falls back to the web API's Open Facts lookup when the curated
 *       catalogue does not carry the code. The returned `ingredientNames` is
 *       the same shape the OCR scan produces, so the client can hand it
 *       straight to `POST /analysis`.
 *     tags: [Products]
 *     security: [{ bearerAuth: [] }]
 *     parameters:
 *       - in: path
 *         name: code
 *         required: true
 *         schema: { type: string, pattern: '^\d{8,14}$' }
 *     responses:
 *       200: { description: The matched product with its ingredient list }
 *       404: { description: Barcode not found — the client offers OCR instead }
 *       422: { description: Malformed barcode }
 */
router.get(
  '/barcode/:code',
  validate({ params: barcodeParamsSchema }),
  async (_req, res) => {
    const { code } = res.locals.params as { code: string };
    const product = await barcodeService.lookup(code);
    if (!product) {
      throw ApiError.notFound(
        'We could not find that barcode. Try scanning the ingredient list instead.',
      );
    }
    sendSuccess(res, product);
  },
);

/**
 * @openapi
 * /products:
 *   get:
 *     summary: Search the product catalog
 *     tags: [Products]
 *     security: [{ bearerAuth: [] }]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema: { type: string }
 *       - in: query
 *         name: category
 *         schema: { type: string }
 *       - in: query
 *         name: page
 *         schema: { type: integer, default: 1 }
 *     responses:
 *       200: { description: Paginated products + available categories }
 */
router.get('/', async (req, res) => {
  const search =
    typeof req.query.search === 'string' ? req.query.search.trim() : '';
  const category =
    typeof req.query.category === 'string' ? req.query.category : '';
  const page = Math.max(1, Number(req.query.page) || 1);

  // Proxied to the web catalogue — see CatalogService. This service holds no
  // product records of its own, so mobile and web always browse the same set.
  const result = await catalogService.list({ search, category, page });

  sendSuccess(
    res,
    { items: result.items, categories: result.categories },
    'Success',
    200,
    {
      page: result.page,
      pageSize: result.pageSize,
      total: result.total,
      totalPages: result.totalPages,
    },
  );
});

/**
 * @openapi
 * /products/{slug}:
 *   get:
 *     summary: Full detail for one catalogue product
 *     description: >
 *       Proxied to the web API, same as the list and barcode endpoints —
 *       fetched when a product from a list/search result is opened, since the
 *       list endpoint only ever returns a summary (no ingredients).
 *     tags: [Products]
 *     security: [{ bearerAuth: [] }]
 *     parameters:
 *       - in: path
 *         name: slug
 *         required: true
 *         schema: { type: string }
 *     responses:
 *       200: { description: The product, with its full ingredient list }
 *       404: { description: Not found }
 */
// Single dynamic segment, registered last: it would otherwise shadow
// /barcode/:code (two segments, so no actual collision) or any future
// single-segment route added above it.
router.get('/:slug', async (req, res) => {
  const detail = await catalogService.detail(req.params.slug as string);
  if (!detail) throw ApiError.notFound('Product not found');
  sendSuccess(res, detail);
});

export default router;
