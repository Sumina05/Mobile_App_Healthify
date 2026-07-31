import { Router } from 'express';
import { z } from 'zod';

import { requireAuth } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { sendSuccess } from '../../utils/api-response';
import { AnalysisModel } from './analysis.model';
import { analysisService } from './analysis.service';

const router = Router();
router.use(requireAuth);

const analyzeSchema = z.object({
  productName: z.string().trim().max(120).optional(),
  brand: z.string().trim().max(80).optional(),
  rawText: z.string().max(20_000).optional(),
  ingredients: z
    .array(z.string().trim().min(2).max(80))
    .min(1, 'At least one ingredient is required')
    .max(80),
});

const compareSchema = z.object({
  analysisIdA: z.string().min(1),
  analysisIdB: z.string().min(1),
});

/**
 * @openapi
 * /analysis:
 *   post:
 *     summary: Analyze a scanned ingredient list
 *     description: >
 *       Matches ingredients against the database, scores suitability for
 *       the user's skin profile, detects allergies/irritants, generates an
 *       AI explanation, computes alternative products, and saves the result.
 *     tags: [Analysis]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       201: { description: The saved analysis with full breakdown }
 */
router.post('/', validate({ body: analyzeSchema }), async (req, res) => {
  const analysis = await analysisService.analyze(req.user!.id, req.body);
  sendSuccess(res, analysis, 'Analysis complete', 201);
});

/**
 * @openapi
 * /analysis/history:
 *   get:
 *     summary: The current user's analysis history (newest first)
 *     tags: [Analysis]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Paginated analyses }
 */
router.get('/history', async (req, res) => {
  const page = Math.max(1, Number(req.query.page) || 1);
  const pageSize = 20;
  const userId = req.user!.id;

  const [items, total] = await Promise.all([
    AnalysisModel.find({ userId })
      .sort({ createdAt: -1 })
      .skip((page - 1) * pageSize)
      .limit(pageSize)
      .exec(),
    AnalysisModel.countDocuments({ userId }).exec(),
  ]);

  sendSuccess(res, { items }, 'Success', 200, {
    page,
    pageSize,
    total,
    totalPages: Math.ceil(total / pageSize),
  });
});

/**
 * @openapi
 * /analysis/compare:
 *   post:
 *     summary: Compare two saved analyses
 *     tags: [Analysis]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Both analyses, winner id, and metric deltas }
 */
router.post('/compare', validate({ body: compareSchema }), async (req, res) => {
  const result = await analysisService.compare(
    req.user!.id,
    req.body.analysisIdA,
    req.body.analysisIdB,
  );
  sendSuccess(res, result);
});

/**
 * @openapi
 * /analysis/{id}:
 *   get:
 *     summary: Full analysis detail
 *     tags: [Analysis]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: The analysis }
 *       404: { description: Not found }
 */
router.get('/:id', async (req, res) => {
  const analysis = await analysisService.getById(
    req.user!.id,
    req.params.id as string,
  );
  sendSuccess(res, analysis);
});

/**
 * @openapi
 * /analysis/{id}/favorite:
 *   patch:
 *     summary: Toggle bookmark on an analysis
 *     tags: [Analysis]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Updated analysis }
 */
router.patch('/:id/favorite', async (req, res) => {
  const analysis = await analysisService.toggleFavorite(
    req.user!.id,
    req.params.id as string,
  );
  sendSuccess(res, analysis, analysis.favorite ? 'Saved' : 'Removed');
});

export default router;
