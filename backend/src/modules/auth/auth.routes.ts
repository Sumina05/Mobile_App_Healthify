import { Router } from 'express';
import rateLimit from 'express-rate-limit';

import { validate } from '../../middlewares/validate.middleware';
import * as controller from './auth.controller';
import {
  forgotPasswordSchema,
  googleLoginSchema,
  loginSchema,
  refreshSchema,
  registerSchema,
  resetPasswordSchema,
} from './auth.validation';

const router = Router();

/** Tighter limit for credential endpoints. */
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  limit: 30,
  standardHeaders: 'draft-8',
  legacyHeaders: false,
  message: { success: false, message: 'Too many attempts, try again later.' },
});

/**
 * @openapi
 * /auth/register:
 *   post:
 *     summary: Create an account
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [name, email, password]
 *             properties:
 *               name: { type: string }
 *               email: { type: string, format: email }
 *               password: { type: string, minLength: 8 }
 *     responses:
 *       201: { description: User + access/refresh token pair }
 *       409: { description: Email already registered }
 */
router.post(
  '/register',
  authLimiter,
  validate({ body: registerSchema }),
  controller.register,
);

/**
 * @openapi
 * /auth/login:
 *   post:
 *     summary: Log in with email and password
 *     tags: [Auth]
 *     responses:
 *       200: { description: User + access/refresh token pair }
 *       401: { description: Incorrect credentials }
 */
router.post(
  '/login',
  authLimiter,
  validate({ body: loginSchema }),
  controller.login,
);

/**
 * @openapi
 * /auth/google:
 *   post:
 *     summary: Sign in (or sign up) with a Google ID token
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [idToken]
 *             properties:
 *               idToken: { type: string }
 *     responses:
 *       200: { description: User + access/refresh token pair }
 *       401: { description: Invalid or unverified Google token }
 */
router.post(
  '/google',
  authLimiter,
  validate({ body: googleLoginSchema }),
  controller.loginWithGoogle,
);

/**
 * @openapi
 * /auth/refresh:
 *   post:
 *     summary: Rotate the refresh token and get a new token pair
 *     tags: [Auth]
 *     responses:
 *       200: { description: New access/refresh token pair }
 *       401: { description: Invalid, expired, or replayed refresh token }
 */
router.post('/refresh', validate({ body: refreshSchema }), controller.refresh);

/**
 * @openapi
 * /auth/logout:
 *   post:
 *     summary: Invalidate a refresh token
 *     tags: [Auth]
 *     responses:
 *       200: { description: Logged out }
 */
router.post('/logout', validate({ body: refreshSchema }), controller.logout);

/**
 * @openapi
 * /auth/forgot-password:
 *   post:
 *     summary: Request a 6-digit password reset code
 *     tags: [Auth]
 *     responses:
 *       200: { description: Always succeeds (does not reveal account existence) }
 */
router.post(
  '/forgot-password',
  authLimiter,
  validate({ body: forgotPasswordSchema }),
  controller.forgotPassword,
);

/**
 * @openapi
 * /auth/reset-password:
 *   post:
 *     summary: Reset the password with the emailed code
 *     tags: [Auth]
 *     responses:
 *       200: { description: Password changed, all sessions revoked }
 *       400: { description: Invalid or expired code }
 */
router.post(
  '/reset-password',
  authLimiter,
  validate({ body: resetPasswordSchema }),
  controller.resetPassword,
);

export default router;
