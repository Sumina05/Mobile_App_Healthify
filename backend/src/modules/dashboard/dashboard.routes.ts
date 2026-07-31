import { Router } from 'express';

import { requireAuth } from '../../middlewares/auth.middleware';
import { sendSuccess } from '../../utils/api-response';
import { AnalysisModel } from '../analysis/analysis.model';
import { ingredientService } from '../ingredients/ingredient.service';
import { notificationService } from '../notifications/notification.service';
import { userService } from '../users/user.service';
import { insightOfTheDay } from './insight.data';

const router = Router();
router.use(requireAuth);

/**
 * @openapi
 * /dashboard:
 *   get:
 *     summary: Aggregated home-screen data in a single round trip
 *     tags: [Dashboard]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200:
 *         description: >
 *           User, today's insight & ingredient, latest skin score, recent
 *           analyses, personalized recommendations, weekly stats, unread count.
 */
router.get('/', async (req, res) => {
  const userId = req.user!.id;
  const user = await userService.getById(userId);

  const weekAgo = new Date(Date.now() - 7 * 86_400_000);
  const [
    todayIngredient,
    recommendations,
    recentAnalyses,
    weeklyScans,
    latestAnalysis,
    unreadNotifications,
  ] = await Promise.all([
    ingredientService.ingredientOfTheDay(),
    ingredientService.recommendedFor(user.skinProfile),
    AnalysisModel.find({ userId }).sort({ createdAt: -1 }).limit(5).exec(),
    AnalysisModel.countDocuments({
      userId,
      createdAt: { $gte: weekAgo },
    }).exec(),
    AnalysisModel.findOne({ userId }).sort({ createdAt: -1 }).exec(),
    notificationService.unreadCount(userId),
  ]);

  const weeklyAgg = await AnalysisModel.aggregate<{ avg: number }>([
    { $match: { userId: user._id, createdAt: { $gte: weekAgo } } },
    { $group: { _id: null, avg: { $avg: '$score' } } },
  ]).exec();

  sendSuccess(res, {
    user: user.toJSON(),
    skinScore: latestAnalysis?.score ?? null,
    todayInsight: insightOfTheDay(),
    todayIngredient,
    recentAnalyses,
    recommendations,
    weeklyStats: {
      scans: weeklyScans,
      averageScore:
        weeklyAgg[0]?.avg != null ? Math.round(weeklyAgg[0].avg) : null,
    },
    unreadNotifications,
  });
});

export default router;
