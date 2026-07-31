import { Router } from 'express';
import { z } from 'zod';

import { requireAuth } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { IngredientModel } from '../ingredients/ingredient.model';
import { FavoriteModel } from './favorite.model';

const router = Router();
router.use(requireAuth);

const addFavoriteSchema = z.object({
  ingredientId: z.string().min(1),
});

/**
 * @openapi
 * /favorites:
 *   get:
 *     summary: The user's favorite ingredients
 *     tags: [Favorites]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Favorites with populated ingredient data }
 */
router.get('/', async (req, res) => {
  const items = await FavoriteModel.find({ userId: req.user!.id })
    .sort({ createdAt: -1 })
    .populate('ingredientId')
    .exec();
  sendSuccess(res, { items });
});

/**
 * @openapi
 * /favorites:
 *   post:
 *     summary: Favorite an ingredient
 *     tags: [Favorites]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       201: { description: Created favorite }
 *       404: { description: Ingredient not found }
 *       409: { description: Already favorited }
 */
router.post('/', validate({ body: addFavoriteSchema }), async (req, res) => {
  const ingredient = await IngredientModel.findById(
    req.body.ingredientId,
  ).exec();
  if (!ingredient) throw ApiError.notFound('Ingredient not found');

  const favorite = await FavoriteModel.create({
    userId: req.user!.id,
    ingredientId: ingredient.id,
  });
  sendSuccess(res, favorite, 'Added to favorites', 201);
});

/**
 * @openapi
 * /favorites/{id}:
 *   delete:
 *     summary: Remove a favorite
 *     tags: [Favorites]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Removed }
 *       404: { description: Not found }
 */
router.delete('/:id', async (req, res) => {
  const deleted = await FavoriteModel.findOneAndDelete({
    _id: req.params.id,
    userId: req.user!.id,
  }).exec();
  if (!deleted) throw ApiError.notFound('Favorite not found');
  sendSuccess(res, null, 'Removed from favorites');
});

export default router;
