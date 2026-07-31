import { OAuth2Client } from 'google-auth-library';

import { env } from '../../config/env';
import { ApiError } from '../../utils/api-error';

export interface GoogleProfile {
  googleId: string;
  email: string;
  name: string;
  avatarUrl?: string;
}

let client: OAuth2Client | null = null;
function getClient(): OAuth2Client {
  client ??= new OAuth2Client(env.GOOGLE_CLIENT_ID);
  return client;
}

/**
 * Verifies a Google ID token entirely server-side against Google's own
 * public keys — no client secret needed, only the (non-secret) client id as
 * the expected audience. Same verification approach as the Healthify web
 * backend's google.service.ts, so the mobile app's native Google Sign-In and
 * the web app's Google Identity Services button share one Google Cloud
 * project and client id.
 */
export const googleService = {
  isConfigured(): boolean {
    return Boolean(env.GOOGLE_CLIENT_ID);
  },

  async verifyIdToken(idToken: string): Promise<GoogleProfile> {
    let ticket;
    try {
      ticket = await getClient().verifyIdToken({ idToken, audience: env.GOOGLE_CLIENT_ID });
    } catch {
      throw ApiError.unauthorized('Invalid Google sign-in token');
    }
    const payload = ticket.getPayload();
    if (!payload?.sub || !payload.email) {
      throw ApiError.unauthorized('Invalid Google sign-in token');
    }
    if (!payload.email_verified) {
      throw ApiError.unauthorized('Your Google account e-mail is not verified');
    }
    return {
      googleId: payload.sub,
      email: payload.email,
      name: payload.name ?? payload.email.split('@')[0]!,
      avatarUrl: payload.picture,
    };
  },
};
