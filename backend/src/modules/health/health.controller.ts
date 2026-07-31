import { RequestHandler } from 'express';

import { isDatabaseConnected } from '../../config/db';
import { sendSuccess } from '../../utils/api-response';

export const getHealth: RequestHandler = (_req, res) => {
  sendSuccess(res, {
    status: 'ok',
    uptime: Math.round(process.uptime()),
    timestamp: new Date().toISOString(),
    database: isDatabaseConnected() ? 'connected' : 'disconnected',
    version: '0.1.0',
  });
};
