import { Router } from 'express';
import { z } from 'zod';

import { requireAuth } from '../../middlewares/auth.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { sendSuccess } from '../../utils/api-response';
import { aiService } from '../ai/ai.service';
import { analysisService } from '../analysis/analysis.service';
import { ingredientService } from '../ingredients/ingredient.service';
import { userService } from '../users/user.service';

const router = Router();
router.use(requireAuth);

const chatSchema = z.object({
  message: z.string().trim().min(1).max(2000),
  analysisId: z.string().optional(),
});

const STOP_WORDS = new RegExp(
  '\\b(what|is|are|the|a|an|about|tell|me|explain|safe|for|my|skin|good|' +
    'bad|why|does|do|should|i|use|it|of|in|this|product|score|how)\\b',
  'g',
);

/**
 * @openapi
 * /chat:
 *   post:
 *     summary: Ask the skincare assistant (AI with database fallback)
 *     tags: [Chat]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Assistant reply, plus ingredient data when matched }
 */
router.post('/', validate({ body: chatSchema }), async (req, res) => {
  const userId = req.user!.id;
  const { message, analysisId } = req.body as {
    message: string;
    analysisId?: string;
  };

  const user = await userService.getById(userId);
  const analysis = analysisId
    ? await analysisService.getById(userId, analysisId)
    : null;

  const context = analysis
    ? JSON.stringify({
        productName: analysis.productName,
        score: analysis.score,
        verdict: analysis.verdict,
        warnings: analysis.warnings,
        breakdown: analysis.breakdown.map((b) => ({
          name: b.name,
          status: b.status,
          reason: b.reason,
        })),
        skinType: user.skinProfile?.skinType,
      })
    : undefined;

  // Database-grounded fallback used when no AI key is configured.
  let matchedIngredient: unknown = null;
  const fallback = async (): Promise<string> => {
    if (analysis) {
      const worst = analysis.breakdown.find(
        (b) => b.status === 'allergy' || b.status === 'avoid',
      );
      const best = analysis.breakdown.find((b) => b.status === 'good');
      return (
        `${analysis.productName} scored ${analysis.score}/100 (${analysis.verdict}). ` +
        `${analysis.recommendationReason} ` +
        (worst ? `Biggest concern: ${worst.name} — ${worst.reason} ` : '') +
        (best ? `Highlight: ${best.name} — ${best.reason}` : '')
      ).trim();
    }
    const keyword = message
      .toLowerCase()
      .replace(STOP_WORDS, ' ')
      .replace(/[^a-z\s-]/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
    const matches = await ingredientService.search(keyword || message, 1);
    const ingredient = matches[0];
    if (!ingredient) {
      return (
        "I don't know that one yet — our ingredient database grows every " +
        'week. Try asking about a specific ingredient like niacinamide, ' +
        'retinol, or ceramides.'
      );
    }
    matchedIngredient = ingredient.toJSON();
    return (
      `${ingredient.name} — ${ingredient.tagline}. ${ingredient.purpose} ` +
      (ingredient.benefits.length > 0
        ? `Benefits: ${ingredient.benefits.join(', ')}. `
        : '') +
      (ingredient.sideEffects.length > 0
        ? `Possible side effects: ${ingredient.sideEffects.join(', ')}.`
        : '')
    ).trim();
  };

  const reply = await aiService.chat({ message, context, fallback });
  sendSuccess(res, { reply, ingredient: matchedIngredient });
});

export default router;
