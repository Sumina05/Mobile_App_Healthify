import { createHash, randomInt } from 'crypto';

import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';

import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ApiError } from '../../utils/api-error';
import { UserRole, signTokenPair, verifyToken } from '../../utils/jwt';
import { notificationService } from '../notifications/notification.service';
import { UserDocument } from '../users/user.model';
import { userRepository } from '../users/user.repository';
import { googleService } from './google.service';
import { RefreshTokenModel } from './token.model';
import { GoogleLoginInput, LoginInput, RegisterInput, ResetPasswordInput } from './auth.validation';

const BCRYPT_ROUNDS = 10;
const RESET_CODE_TTL_MS = 15 * 60 * 1000;

function sha256(value: string): string {
  return createHash('sha256').update(value).digest('hex');
}

function refreshExpiryDate(token: string): Date {
  const decoded = jwt.decode(token) as { exp?: number } | null;
  return decoded?.exp
    ? new Date(decoded.exp * 1000)
    : new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
}

export interface AuthResult {
  user: UserDocument;
  tokens: { accessToken: string; refreshToken: string };
}

export class AuthService {
  private async issueTokens(userId: string, role: UserRole) {
    const tokens = signTokenPair(userId, role);
    await RefreshTokenModel.create({
      userId,
      tokenHash: sha256(tokens.refreshToken),
      expiresAt: refreshExpiryDate(tokens.refreshToken),
    });
    return tokens;
  }

  async register(input: RegisterInput): Promise<AuthResult> {
    const existing = await userRepository.findByEmail(input.email);
    if (existing) {
      throw ApiError.conflict('An account with this email already exists');
    }

    const passwordHash = await bcrypt.hash(input.password, BCRYPT_ROUNDS);
    const user = await userRepository.create({
      name: input.name,
      email: input.email,
      passwordHash,
    });

    await notificationService.create(
      user.id,
      'Welcome to Healthify 🌿',
      'Complete your skin profile to unlock personalized ingredient analysis.',
      'welcome',
    );

    const tokens = await this.issueTokens(user.id, user.role);
    return { user, tokens };
  }

  async login(input: LoginInput): Promise<AuthResult> {
    const user = await userRepository.findByEmailWithSecrets(input.email);
    if (!user || !user.passwordHash || !(await bcrypt.compare(input.password, user.passwordHash))) {
      throw ApiError.unauthorized('Incorrect email or password');
    }
    const tokens = await this.issueTokens(user.id, user.role);
    return { user, tokens };
  }

  /**
   * Same find-or-link-or-create semantics as the web backend's
   * loginWithGoogle: match by googleId first, then by verified e-mail (link
   * rather than duplicate), otherwise create a brand-new account. Operates
   * on this API's own User collection — mobile and web accounts are
   * separate databases, so this is a port of the logic, not a proxy.
   */
  async loginWithGoogle(input: GoogleLoginInput): Promise<AuthResult> {
    if (!googleService.isConfigured()) {
      throw ApiError.internal('Google Sign-In is not configured on this server');
    }
    const profile = await googleService.verifyIdToken(input.idToken);

    let user = await userRepository.findByGoogleId(profile.googleId);
    if (!user) {
      const existingByEmail = await userRepository.findByEmail(profile.email);
      if (existingByEmail) {
        user = await userRepository.linkGoogleId(existingByEmail.id, profile.googleId);
      } else {
        user = await userRepository.create({
          name: profile.name,
          email: profile.email,
          provider: 'google',
          googleId: profile.googleId,
          avatarUrl: profile.avatarUrl,
        });
        await notificationService.create(
          user.id,
          'Welcome to Healthify 🌿',
          'Complete your skin profile to unlock personalized ingredient analysis.',
          'welcome',
        );
      }
    }
    if (!user) throw ApiError.internal('Could not sign in with Google');

    const tokens = await this.issueTokens(user.id, user.role);
    return { user, tokens };
  }

  /** Rotates the refresh token: old one is invalidated atomically. */
  async refresh(refreshToken: string) {
    const payload = verifyToken(refreshToken, 'refresh');
    const deleted = await RefreshTokenModel.findOneAndDelete({
      tokenHash: sha256(refreshToken),
    }).exec();
    if (!deleted) {
      // Token replay after rotation — revoke the whole session family.
      await RefreshTokenModel.deleteMany({ userId: payload.sub }).exec();
      throw ApiError.unauthorized('Session expired, please log in again');
    }
    return this.issueTokens(payload.sub, payload.role);
  }

  async logout(refreshToken: string): Promise<void> {
    await RefreshTokenModel.deleteOne({
      tokenHash: sha256(refreshToken),
    }).exec();
  }

  /**
   * Issues a 6-digit reset code. Without an email provider wired up the
   * code is logged server-side and (in non-production only) returned to
   * the client so the flow is fully testable end-to-end.
   */
  async forgotPassword(email: string): Promise<string | null> {
    const user = await userRepository.findByEmail(email);
    if (!user) return null; // Do not reveal whether the account exists.

    const code = String(randomInt(100000, 1000000));
    await userRepository.setPasswordReset(user.id, {
      codeHash: sha256(code),
      expiresAt: new Date(Date.now() + RESET_CODE_TTL_MS),
    });
    logger.info(`Password reset code for ${email}: ${code}`);
    return env.NODE_ENV === 'production' ? null : code;
  }

  async resetPassword(input: ResetPasswordInput): Promise<void> {
    const user = await userRepository.findByEmailWithSecrets(input.email);
    const reset = user?.passwordReset;
    if (
      !user ||
      !reset ||
      reset.expiresAt.getTime() < Date.now() ||
      reset.codeHash !== sha256(input.code)
    ) {
      throw ApiError.badRequest('Invalid or expired reset code');
    }

    const passwordHash = await bcrypt.hash(input.password, BCRYPT_ROUNDS);
    await userRepository.updatePassword(user.id, passwordHash);
    // Force re-login everywhere after a password change.
    await RefreshTokenModel.deleteMany({ userId: user.id }).exec();
  }
}

export const authService = new AuthService();
