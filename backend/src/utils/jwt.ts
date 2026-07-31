import { randomUUID } from 'crypto';

import jwt, { SignOptions } from 'jsonwebtoken';

import { env } from '../config/env';
import { ApiError } from './api-error';

export type TokenType = 'access' | 'refresh';
export type UserRole = 'user' | 'admin';

export interface TokenPayload {
  sub: string;
  role: UserRole;
  type: TokenType;
}

function secretFor(type: TokenType): string {
  return type === 'access' ? env.JWT_ACCESS_SECRET : env.JWT_REFRESH_SECRET;
}

function expiryFor(type: TokenType): SignOptions['expiresIn'] {
  return (
    type === 'access' ? env.JWT_ACCESS_EXPIRES : env.JWT_REFRESH_EXPIRES
  ) as SignOptions['expiresIn'];
}

export function signToken(
  userId: string,
  role: UserRole,
  type: TokenType,
): string {
  const payload: TokenPayload = { sub: userId, role, type };
  // jti guarantees uniqueness even for pairs signed in the same second.
  return jwt.sign(payload, secretFor(type), {
    expiresIn: expiryFor(type),
    jwtid: randomUUID(),
  });
}

export function signTokenPair(userId: string, role: UserRole) {
  return {
    accessToken: signToken(userId, role, 'access'),
    refreshToken: signToken(userId, role, 'refresh'),
  };
}

/** Verifies signature, expiry, and that the token is of the expected type. */
export function verifyToken(token: string, expectedType: TokenType): TokenPayload {
  try {
    const decoded = jwt.verify(token, secretFor(expectedType));
    if (
      typeof decoded !== 'object' ||
      decoded === null ||
      (decoded as TokenPayload).type !== expectedType
    ) {
      throw ApiError.unauthorized('Invalid token');
    }
    return decoded as TokenPayload;
  } catch (error) {
    if (error instanceof ApiError) throw error;
    if (error instanceof jwt.TokenExpiredError) {
      throw ApiError.unauthorized('Token expired');
    }
    throw ApiError.unauthorized('Invalid token');
  }
}
