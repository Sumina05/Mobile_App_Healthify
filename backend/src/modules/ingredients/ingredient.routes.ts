import { Router } from 'express';

import { requireAuth } from '../../middlewares/auth.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { userService } from '../users/user.service';
import { ingredientService } from './ingredient.service';

const router = Router();
router.use(requireAuth);

/**
 * @openapi
 * /ingredients:
 *   get:
 *     summary: Search the ingredient database
 *     tags: [Ingredients]
 *     security: [{ bearerAuth: [] }]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema: { type: string }
 *     responses:
 *       200: { description: Matching ingredients }
 */
router.get('/', async (req, res) => {
  const search =
    typeof req.query.search === 'string' ? req.query.search : undefined;
  const items = await ingredientService.search(search);
  sendSuccess(res, { items });
});

/**
 * @openapi
 * /ingredients/daily:
 *   get:
 *     summary: Ingredient of the day
 *     tags: [Ingredients]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Today's featured ingredient }
 */
router.get('/daily', async (_req, res) => {
  const ingredient = await ingredientService.ingredientOfTheDay();
  sendSuccess(res, ingredient);
});

/**
 * @openapi
 * /ingredients/recommended:
 *   get:
 *     summary: Ingredients recommended for the current user's skin profile
 *     tags: [Ingredients]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Ranked ingredient recommendations }
 */
router.get('/recommended', async (req, res) => {
  const user = await userService.getById(req.user!.id);
  const items = await ingredientService.recommendedFor(user.skinProfile);
  sendSuccess(res, { items });
});

/**
 * @openapi
 * /ingredients/{id}:
 *   get:
 *     summary: Ingredient detail
 *     tags: [Ingredients]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: The ingredient }
 *       404: { description: Not found }
 */
router.get('/:id', async (req, res) => {
  const ingredient = await ingredientService.getById(req.params.id as string);
  if (!ingredient) throw ApiError.notFound('Ingredient not found');
  sendSuccess(res, ingredient);
});

export default router;
