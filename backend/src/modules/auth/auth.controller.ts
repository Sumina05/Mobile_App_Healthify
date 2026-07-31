import { RequestHandler } from 'express';
import { StatusCodes } from 'http-status-codes';

import { sendSuccess } from '../../utils/api-response';
import { authService } from './auth.service';

export const register: RequestHandler = async (req, res) => {
  const { user, tokens } = await authService.register(req.body);
  sendSuccess(
    res,
    { user: user.toJSON(), tokens },
    'Account created',
    StatusCodes.CREATED,
  );
};

export const login: RequestHandler = async (req, res) => {
  const { user, tokens } = await authService.login(req.body);
  sendSuccess(res, { user: user.toJSON(), tokens }, 'Logged in');
};

export const loginWithGoogle: RequestHandler = async (req, res) => {
  const { user, tokens } = await authService.loginWithGoogle(req.body);
  sendSuccess(res, { user: user.toJSON(), tokens }, 'Logged in with Google');
};

export const refresh: RequestHandler = async (req, res) => {
  const tokens = await authService.refresh(req.body.refreshToken);
  sendSuccess(res, { tokens }, 'Session refreshed');
};

export const logout: RequestHandler = async (req, res) => {
  await authService.logout(req.body.refreshToken);
  sendSuccess(res, null, 'Logged out');
};

export const forgotPassword: RequestHandler = async (req, res) => {
  const devCode = await authService.forgotPassword(req.body.email);
  sendSuccess(
    res,
    devCode ? { devCode } : null,
    'If an account exists for this email, a reset code has been sent.',
  );
};

export const resetPassword: RequestHandler = async (req, res) => {
  await authService.resetPassword(req.body);
  sendSuccess(res, null, 'Password updated — please log in');
};
