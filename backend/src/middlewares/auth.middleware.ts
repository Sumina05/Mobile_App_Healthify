import { RequestHandler } from 'express';

import { ApiError } from '../utils/api-error';
import { verifyToken } from '../utils/jwt';

/** Verifies the bearer access token and attaches req.user. */
export const requireAuth: RequestHandler = (req, _res, next) => {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    throw ApiError.unauthorized();
  }
  const payload = verifyToken(header.slice('Bearer '.length), 'access');
  req.user = { id: payload.sub, role: payload.role };
  next();
};

export const requireAdmin: RequestHandler = (req, _res, next) => {
  if (req.user?.role !== 'admin') {
    throw ApiError.forbidden('Admin access required');
  }
  next();
};
