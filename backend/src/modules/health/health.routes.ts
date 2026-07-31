import { Router } from 'express';

import { getHealth } from './health.controller';

const router = Router();

/**
 * @openapi
 * /health:
 *   get:
 *     summary: API health check
 *     tags: [Health]
 *     responses:
 *       200:
 *         description: Service status, uptime, and database connectivity.
 */
router.get('/', getHealth);

export default router;
