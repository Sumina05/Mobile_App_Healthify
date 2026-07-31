import { Router } from 'express';
import { z } from 'zod';

import {
  requireAdmin,
  requireAuth,
} from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { AnalysisModel } from '../analysis/analysis.model';
import {
  IngredientModel,
  SAFETY_RATINGS,
} from '../ingredients/ingredient.model';
import { PaymentModel } from '../premium/payment.model';
import { ProductModel } from '../products/product.model';
import { UserModel } from '../users/user.model';

const router = Router();
router.use(requireAuth, requireAdmin);

const ingredientSchema = z.object({
  name: z.string().trim().min(2).max(80),
  aliases: z.array(z.string().trim().min(1)).default([]),
  tagline: z.string().min(3).max(120),
  purpose: z.string().min(3),
  description: z.string().min(3),
  benefits: z.array(z.string()).default([]),
  sideEffects: z.array(z.string()).default([]),
  safetyRating: z.enum(SAFETY_RATINGS),
  goodForSkinTypes: z.array(z.string()).default([]),
  cautionForSkinTypes: z.array(z.string()).default([]),
  concernsTargeted: z.array(z.string()).default([]),
  isCommonAllergen: z.boolean().default(false),
});

const productSchema = z.object({
  name: z.string().trim().min(2).max(120),
  brand: z.string().trim().min(1).max(80),
  category: z.string().trim().min(2).max(60),
  ingredientNames: z.array(z.string().trim().min(1)).min(1),
});

/**
 * @openapi
 * /admin/stats:
 *   get:
 *     summary: Platform analytics for the admin dashboard
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Users, scans, revenue, score stats, top ingredients }
 */
router.get('/stats', async (_req, res) => {
  const weekAgo = new Date(Date.now() - 7 * 86_400_000);
  const [
    totalUsers,
    premiumUsers,
    totalAnalyses,
    weeklyAnalyses,
    ingredientCount,
    productCount,
    scoreAgg,
    revenueAgg,
    topIngredients,
  ] = await Promise.all([
    UserModel.countDocuments().exec(),
    UserModel.countDocuments({ premium: { $ne: null } }).exec(),
    AnalysisModel.countDocuments().exec(),
    AnalysisModel.countDocuments({ createdAt: { $gte: weekAgo } }).exec(),
    IngredientModel.estimatedDocumentCount().exec(),
    ProductModel.estimatedDocumentCount().exec(),
    AnalysisModel.aggregate<{ avg: number }>([
      { $group: { _id: null, avg: { $avg: '$score' } } },
    ]).exec(),
    PaymentModel.aggregate<{ total: number }>([
      { $match: { status: 'completed' } },
      { $group: { _id: null, total: { $sum: '$amountNpr' } } },
    ]).exec(),
    AnalysisModel.aggregate<{ _id: string; count: number }>([
      { $unwind: '$breakdown' },
      { $match: { 'breakdown.matched': true } },
      { $group: { _id: '$breakdown.name', count: { $sum: 1 } } },
      { $sort: { count: -1 } },
      { $limit: 5 },
    ]).exec(),
  ]);

  sendSuccess(res, {
    users: { total: totalUsers, premium: premiumUsers },
    analyses: {
      total: totalAnalyses,
      thisWeek: weeklyAnalyses,
      averageScore:
        scoreAgg[0]?.avg != null ? Math.round(scoreAgg[0].avg) : null,
    },
    catalog: { ingredients: ingredientCount, products: productCount },
    revenueNpr: revenueAgg[0]?.total ?? 0,
    topScannedIngredients: topIngredients.map((t) => ({
      name: t._id,
      count: t.count,
    })),
  });
});

/**
 * @openapi
 * /admin/ingredients:
 *   post:
 *     summary: Add an ingredient to the database
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       201: { description: Created ingredient }
 */
router.post(
  '/ingredients',
  validate({ body: ingredientSchema }),
  async (req, res) => {
    const ingredient = await IngredientModel.create(req.body);
    sendSuccess(res, ingredient, 'Ingredient created', 201);
  },
);

/**
 * @openapi
 * /admin/ingredients/{id}:
 *   patch:
 *     summary: Update an ingredient
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Updated ingredient }
 */
router.patch(
  '/ingredients/:id',
  validate({ body: ingredientSchema.partial() }),
  async (req, res) => {
    const ingredient = await IngredientModel.findByIdAndUpdate(
      req.params.id,
      req.body,
      { returnDocument: 'after', runValidators: true },
    ).exec();
    if (!ingredient) throw ApiError.notFound('Ingredient not found');
    sendSuccess(res, ingredient, 'Ingredient updated');
  },
);

/**
 * @openapi
 * /admin/ingredients/{id}:
 *   delete:
 *     summary: Remove an ingredient
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Deleted }
 */
router.delete('/ingredients/:id', async (req, res) => {
  const deleted = await IngredientModel.findByIdAndDelete(
    req.params.id,
  ).exec();
  if (!deleted) throw ApiError.notFound('Ingredient not found');
  sendSuccess(res, null, 'Ingredient deleted');
});

/**
 * @openapi
 * /admin/products:
 *   post:
 *     summary: Add a catalog product
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       201: { description: Created product }
 */
router.post(
  '/products',
  validate({ body: productSchema }),
  async (req, res) => {
    const product = await ProductModel.create(req.body);
    sendSuccess(res, product, 'Product created', 201);
  },
);

/**
 * @openapi
 * /admin/products/{id}:
 *   delete:
 *     summary: Remove a catalog product
 *     tags: [Admin]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Deleted }
 */
router.delete('/products/:id', async (req, res) => {
  const deleted = await ProductModel.findByIdAndDelete(req.params.id).exec();
  if (!deleted) throw ApiError.notFound('Product not found');
  sendSuccess(res, null, 'Product deleted');
});

export default router;
