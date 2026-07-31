import { StatusCodes } from 'http-status-codes';

/** Operational error carrying an HTTP status and optional field details. */
export class ApiError extends Error {
  constructor(
    public readonly statusCode: number,
    message: string,
    public readonly details?: Record<string, unknown>,
    public readonly isOperational = true,
  ) {
    super(message);
    this.name = 'ApiError';
    Error.captureStackTrace(this, this.constructor);
  }

  static badRequest(message: string, details?: Record<string, unknown>) {
    return new ApiError(StatusCodes.BAD_REQUEST, message, details);
  }

  static unauthorized(message = 'Authentication required') {
    return new ApiError(StatusCodes.UNAUTHORIZED, message);
  }

  static forbidden(message = 'You do not have access to this resource') {
    return new ApiError(StatusCodes.FORBIDDEN, message);
  }

  static notFound(message = 'Resource not found') {
    return new ApiError(StatusCodes.NOT_FOUND, message);
  }

  static conflict(message: string) {
    return new ApiError(StatusCodes.CONFLICT, message);
  }

  static unprocessable(message: string, details?: Record<string, unknown>) {
    return new ApiError(StatusCodes.UNPROCESSABLE_ENTITY, message, details);
  }

  static internal(message = 'Something went wrong') {
    return new ApiError(
      StatusCodes.INTERNAL_SERVER_ERROR,
      message,
      undefined,
      false,
    );
  }
}
