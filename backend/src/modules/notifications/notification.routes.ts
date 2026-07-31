import { Router } from 'express';

import { requireAuth } from '../../middlewares/auth.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { notificationService } from './notification.service';

const router = Router();
router.use(requireAuth);

/**
 * @openapi
 * /notifications:
 *   get:
 *     summary: List the current user's notifications (newest first)
 *     tags: [Notifications]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Notifications + unread count }
 */
router.get('/', async (req, res) => {
  const userId = req.user!.id;
  const [items, unread] = await Promise.all([
    notificationService.listForUser(userId),
    notificationService.unreadCount(userId),
  ]);
  sendSuccess(res, { items, unread });
});

/**
 * @openapi
 * /notifications/read-all:
 *   post:
 *     summary: Mark every notification as read
 *     tags: [Notifications]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: All marked read }
 */
router.post('/read-all', async (req, res) => {
  await notificationService.markAllRead(req.user!.id);
  sendSuccess(res, null, 'All notifications marked as read');
});

/**
 * @openapi
 * /notifications/{id}/read:
 *   patch:
 *     summary: Mark one notification as read
 *     tags: [Notifications]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Updated notification }
 *       404: { description: Not found }
 */
router.patch('/:id/read', async (req, res) => {
  const updated = await notificationService.markRead(
    req.user!.id,
    req.params.id as string,
  );
  if (!updated) throw ApiError.notFound('Notification not found');
  sendSuccess(res, updated);
});

export default router;
