import { Router } from 'express';

import { requireAuth } from '../../middlewares/auth.middleware';
import {
  createDiskUpload,
  publicUploadUrl,
  wrapUpload,
} from '../../middlewares/disk-upload.middleware';
import { validate } from '../../middlewares/validate.middleware';
import { ApiError } from '../../utils/api-error';
import { sendSuccess } from '../../utils/api-response';
import { userService } from './user.service';
import { skinProfileSchema, updateMeSchema } from './user.validation';

const router = Router();
router.use(requireAuth);

/**
 * @openapi
 * /users/me:
 *   get:
 *     summary: Current user profile
 *     tags: [Users]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: The authenticated user }
 */
router.get('/me', async (req, res) => {
  const user = await userService.getById(req.user!.id);
  sendSuccess(res, user);
});

/**
 * @openapi
 * /users/me:
 *   patch:
 *     summary: Update name / avatar
 *     tags: [Users]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: Updated user }
 */
router.patch('/me', validate({ body: updateMeSchema }), async (req, res) => {
  const user = await userService.updateMe(req.user!.id, req.body);
  sendSuccess(res, user, 'Profile updated');
});

/**
 * @openapi
 * /users/me/avatar:
 *   post:
 *     summary: Upload or replace the current user's profile picture
 *     description: >
 *       Multipart form with an `image` field (JPG/PNG/WEBP, max 5 MB). The
 *       file is stored on disk and served from /uploads; the resulting URL is
 *       saved to the user's avatarUrl and returned with the updated user.
 *     tags: [Users]
 *     security: [{ bearerAuth: [] }]
 *     requestBody:
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               image: { type: string, format: binary }
 *     responses:
 *       200: { description: Updated user carrying the new avatarUrl }
 *       400: { description: Missing or unsupported image }
 */
router.post(
  '/me/avatar',
  wrapUpload(createDiskUpload('avatars')),
  async (req, res) => {
    if (!req.file) throw ApiError.badRequest('No image was uploaded');
    const avatarUrl = publicUploadUrl(req, 'avatars', req.file.filename);
    const user = await userService.updateMe(req.user!.id, { avatarUrl });
    sendSuccess(res, user, 'Profile picture updated');
  },
);

/**
 * @openapi
 * /users/me/skin-profile:
 *   put:
 *     summary: Create or replace the skin profile
 *     tags: [Users]
 *     security: [{ bearerAuth: [] }]
 *     responses:
 *       200: { description: User with the saved skin profile }
 *       422: { description: Validation failed }
 */
router.put(
  '/me/skin-profile',
  validate({ body: skinProfileSchema }),
  async (req, res) => {
    const user = await userService.setSkinProfile(req.user!.id, req.body);
    sendSuccess(res, user, 'Skin profile saved');
  },
);

export default router;
