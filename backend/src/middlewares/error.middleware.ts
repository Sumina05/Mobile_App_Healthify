import { NextFunction, Request, RequestHandler, Response } from 'express';
import { StatusCodes } from 'http-status-codes';
import mongoose from 'mongoose';
import { ZodError } from 'zod';

import { env } from '../config/env';
import { logger } from '../config/logger';
import { ApiError } from '../utils/api-error';

export const notFoundHandler: RequestHandler = (req, _res, next) => {
  next(ApiError.notFound(`Route ${req.method} ${req.originalUrl} not found`));
};

function normalize(err: unknown): ApiError {
  if (err instanceof ApiError) return err;

  if (err instanceof ZodError) {
    const fieldErrors: Record<string, string[]> = {};
    for (const issue of err.issues) {
      const field = issue.path.join('.') || '_root';
      (fieldErrors[field] ??= []).push(issue.message);
    }
    return ApiError.unprocessable('Validation failed', fieldErrors);
  }

  if (err instanceof mongoose.Error.ValidationError) {
    const fieldErrors: Record<string, string[]> = {};
    for (const [field, e] of Object.entries(err.errors)) {
      fieldErrors[field] = [e.message];
    }
    return ApiError.unprocessable('Validation failed', fieldErrors);
  }

  if (err instanceof mongoose.Error.CastError) {
    return ApiError.badRequest(`Invalid value for ${err.path}`);
  }

  // Mongo duplicate key
  if (
    typeof err === 'object' &&
    err !== null &&
    (err as { code?: number }).code === 11000
  ) {
    return ApiError.conflict('A record with this value already exists');
  }

  return ApiError.internal();
}

export function errorHandler(
  err: unknown,
  req: Request,
  res: Response,
  _next: NextFunction,
): void {
  const error = normalize(err);

  if (error.statusCode >= 500) {
    logger.error(
      `${req.method} ${req.originalUrl} → ${error.statusCode}`,
      err instanceof Error ? { stack: err.stack } : { err },
    );
  } else {
    logger.warn(`${req.method} ${req.originalUrl} → ${error.statusCode}: ${error.message}`);
  }

  res.status(error.statusCode).json({
    success: false,
    message:
      error.statusCode === StatusCodes.INTERNAL_SERVER_ERROR &&
      env.NODE_ENV === 'production'
        ? 'Something went wrong'
        : error.message,
    ...(error.details ? { errors: error.details } : {}),
    ...(env.NODE_ENV === 'development' && err instanceof Error
      ? { stack: err.stack }
      : {}),
  });
}
