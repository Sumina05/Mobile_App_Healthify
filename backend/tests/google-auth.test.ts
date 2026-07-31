import mongoose from 'mongoose';
import { afterAll, afterEach, beforeAll, describe, expect, it, vi } from 'vitest';

import { authService } from '../src/modules/auth/auth.service';
import { googleService } from '../src/modules/auth/google.service';
import { userRepository } from '../src/modules/users/user.repository';

/**
 * Exercises loginWithGoogle's find-or-link-or-create logic directly against
 * a real MongoDB, with only the Google token verification mocked (there's no
 * real Google account to authenticate as in a test run). Skipped when Mongo
 * isn't reachable, same as auth.flow.test.ts.
 */
const TEST_URI = 'mongodb://127.0.0.1:27017/healthify_google_test';

let dbAvailable = false;

beforeAll(async () => {
  try {
    await mongoose.connect(TEST_URI, { serverSelectionTimeoutMS: 3000 });
    await mongoose.connection.dropDatabase();
    dbAvailable = true;
  } catch {
    dbAvailable = false;
  }
});

afterEach(() => {
  vi.restoreAllMocks();
});

afterAll(async () => {
  if (dbAvailable) {
    await mongoose.connection.dropDatabase();
    await mongoose.disconnect();
  }
});

function mockGoogleProfile(profile: {
  googleId: string;
  email: string;
  name: string;
}) {
  vi.spyOn(googleService, 'isConfigured').mockReturnValue(true);
  vi.spyOn(googleService, 'verifyIdToken').mockResolvedValue(profile);
}

describe('loginWithGoogle', () => {
  it('creates a brand-new account on first sign-in', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    mockGoogleProfile({
      googleId: 'google-uid-1',
      email: 'new.user@gmail.com',
      name: 'New User',
    });

    const { user, tokens } = await authService.loginWithGoogle({ idToken: 'x' });

    expect(user.email).toBe('new.user@gmail.com');
    expect(user.provider).toBe('google');
    expect(user.googleId).toBe('google-uid-1');
    expect(tokens.accessToken).toBeTypeOf('string');
  });

  it('signs the same Google account back in without creating a duplicate', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    mockGoogleProfile({
      googleId: 'google-uid-2',
      email: 'repeat.user@gmail.com',
      name: 'Repeat User',
    });
    const first = await authService.loginWithGoogle({ idToken: 'x' });
    const second = await authService.loginWithGoogle({ idToken: 'x' });

    expect(second.user.id).toBe(first.user.id);
    const count = await userRepository.findByGoogleId('google-uid-2');
    expect(count).not.toBeNull();
  });

  it('links Google to an existing local account with the same verified e-mail', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const local = await userRepository.create({
      name: 'Local Sarah',
      email: 'sarah.local@gmail.com',
      passwordHash: 'irrelevant-hash',
    });

    mockGoogleProfile({
      googleId: 'google-uid-3',
      email: 'sarah.local@gmail.com',
      name: 'Sarah From Google',
    });
    const { user } = await authService.loginWithGoogle({ idToken: 'x' });

    expect(user.id).toBe(local.id);
    expect(user.googleId).toBe('google-uid-3');
    expect(user.provider).toBe('google');
  });
});
