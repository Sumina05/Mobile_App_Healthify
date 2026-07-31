import { Response } from 'express';
import { StatusCodes } from 'http-status-codes';

/**
 * Success envelope used by every endpoint:
 * `{ success: true, message, data, meta? }`
 */
export function sendSuccess<T>(
  res: Response,
  data: T,
  message = 'Success',
  statusCode: number = StatusCodes.OK,
  meta?: Record<string, unknown>,
): void {
  res.status(statusCode).json({
    success: true,
    message,
    data,
    ...(meta ? { meta } : {}),
  });
}
