import { describe, expect, it } from 'vitest';

import { ApiError } from '../src/utils/api-error';
import { signToken, signTokenPair, verifyToken } from '../src/utils/jwt';

describe('jwt utils', () => {
  it('signs and verifies an access token round-trip', () => {
    const token = signToken('user-123', 'user', 'access');
    const payload = verifyToken(token, 'access');

    expect(payload.sub).toBe('user-123');
    expect(payload.role).toBe('user');
    expect(payload.type).toBe('access');
  });

  it('issues distinct access and refresh tokens', () => {
    const pair = signTokenPair('user-123', 'user');
    expect(pair.accessToken).not.toBe(pair.refreshToken);
  });

  it('rejects a refresh token presented as an access token', () => {
    const refresh = signToken('user-123', 'user', 'refresh');
    expect(() => verifyToken(refresh, 'access')).toThrow(ApiError);
  });

  it('rejects tampered tokens', () => {
    const token = signToken('user-123', 'admin', 'access');
    expect(() => verifyToken(`${token}x`, 'access')).toThrow(ApiError);
  });
});
