import bcrypt from 'bcryptjs';
import mongoose from 'mongoose';
import request from 'supertest';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';

import { createApp } from '../src/app';
import { env } from '../src/config/env';
import { UserModel } from '../src/modules/users/user.model';
import { seedUsers } from '../src/modules/users/user.seed';

const TEST_URI = 'mongodb://127.0.0.1:27017/healthify_seed_test';

let dbAvailable = false;
const app = createApp();

beforeAll(async () => {
  try {
    await mongoose.connect(TEST_URI, { serverSelectionTimeoutMS: 3000 });
    await mongoose.connection.dropDatabase();
    dbAvailable = true;
  } catch {
    dbAvailable = false;
  }
});

afterAll(async () => {
  if (dbAvailable) {
    await mongoose.connection.dropDatabase();
    await mongoose.disconnect();
  }
});

describe('account seeder', () => {
  it('creates the admin and demo accounts with hashed passwords',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      await seedUsers();

      const admin = await UserModel.findOne({ email: env.ADMIN_EMAIL })
        .select('+passwordHash')
        .exec();
      const demo = await UserModel.findOne({ email: env.DEMO_EMAIL })
        .select('+passwordHash')
        .exec();

      expect(admin).not.toBeNull();
      expect(admin!.role).toBe('admin');
      expect(demo).not.toBeNull();
      expect(demo!.role).toBe('user');

      // Passwords are bcrypt hashes, never stored in the clear.
      expect(admin!.passwordHash).not.toBe(env.ADMIN_PASSWORD);
      expect(admin!.passwordHash.startsWith('$2')).toBe(true);
      expect(await bcrypt.compare(env.ADMIN_PASSWORD, admin!.passwordHash))
        .toBe(true);
      expect(await bcrypt.compare(env.DEMO_PASSWORD, demo!.passwordHash))
        .toBe(true);
    });

  it('is idempotent — re-running creates no duplicates', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    await seedUsers();
    await seedUsers();

    expect(await UserModel.countDocuments({ email: env.ADMIN_EMAIL }).exec())
      .toBe(1);
    expect(await UserModel.countDocuments({ email: env.DEMO_EMAIL }).exec())
      .toBe(1);
  });

  it('does not overwrite a password the user has since changed',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      const changed = await bcrypt.hash('TheyChangedIt99', 10);
      await UserModel.updateOne(
        { email: env.DEMO_EMAIL },
        { passwordHash: changed },
      ).exec();

      await seedUsers();

      const demo = await UserModel.findOne({ email: env.DEMO_EMAIL })
        .select('+passwordHash')
        .exec();
      expect(await bcrypt.compare('TheyChangedIt99', demo!.passwordHash))
        .toBe(true);
    });

  it('resets the password when forced', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    await seedUsers({ force: true });

    const demo = await UserModel.findOne({ email: env.DEMO_EMAIL })
      .select('+passwordHash')
      .exec();
    expect(await bcrypt.compare(env.DEMO_PASSWORD, demo!.passwordHash))
      .toBe(true);
  });

  it('promotes an account that was registered through the API first',
    async (ctx) => {
      if (!dbAvailable) return ctx.skip();

      await UserModel.deleteOne({ email: env.ADMIN_EMAIL }).exec();
      await request(app).post('/api/v1/auth/register').send({
        name: 'Not An Admin Yet',
        email: env.ADMIN_EMAIL,
        password: 'Registered2026',
      });

      const before = await UserModel.findOne({ email: env.ADMIN_EMAIL }).exec();
      expect(before!.role).toBe('user');

      await seedUsers();

      const after = await UserModel.findOne({ email: env.ADMIN_EMAIL }).exec();
      expect(after!.role).toBe('admin');
    });

  it('seeded admin can log in and reach an admin-only route', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    await seedUsers({ force: true });

    const login = await request(app).post('/api/v1/auth/login').send({
      email: env.ADMIN_EMAIL,
      password: env.ADMIN_PASSWORD,
    });
    expect(login.status).toBe(200);

    const stats = await request(app)
      .get('/api/v1/admin/stats')
      .set('Authorization', `Bearer ${login.body.data.tokens.accessToken}`);
    expect(stats.status).toBe(200);
  });

  it('seeded demo user can log in but is denied admin routes', async (ctx) => {
    if (!dbAvailable) return ctx.skip();

    const login = await request(app).post('/api/v1/auth/login').send({
      email: env.DEMO_EMAIL,
      password: env.DEMO_PASSWORD,
    });
    expect(login.status).toBe(200);

    const denied = await request(app)
      .get('/api/v1/admin/stats')
      .set('Authorization', `Bearer ${login.body.data.tokens.accessToken}`);
    expect(denied.status).toBe(403);
  });
});
