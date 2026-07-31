import bcrypt from 'bcryptjs';

import {
  DEFAULT_ADMIN_PASSWORD,
  DEFAULT_DEMO_PASSWORD,
  env,
} from '../../config/env';
import { logger } from '../../config/logger';
import { UserRole } from '../../utils/jwt';
import { notificationService } from '../notifications/notification.service';
import { UserModel } from './user.model';
import { userRepository } from './user.repository';

const BCRYPT_ROUNDS = 10;

interface SeedAccount {
  label: string;
  name: string;
  email: string;
  password: string;
  role: UserRole;
  /** True when [password] is still the publicly-known demo default. */
  usesDefaultPassword: boolean;
}

function seedAccounts(): SeedAccount[] {
  return [
    {
      label: 'admin',
      name: env.ADMIN_NAME,
      email: env.ADMIN_EMAIL,
      password: env.ADMIN_PASSWORD,
      role: 'admin',
      usesDefaultPassword: env.ADMIN_PASSWORD === DEFAULT_ADMIN_PASSWORD,
    },
    {
      label: 'demo user',
      name: env.DEMO_NAME,
      email: env.DEMO_EMAIL,
      password: env.DEMO_PASSWORD,
      role: 'user',
      usesDefaultPassword: env.DEMO_PASSWORD === DEFAULT_DEMO_PASSWORD,
    },
  ];
}

/**
 * Creates the admin and demo accounts when they are missing. Idempotent:
 * an existing account is never duplicated and its password is never
 * rewritten, so re-running (or a restart) cannot silently reset a password
 * someone has since changed. An existing account that is not yet an admin
 * is promoted, which is the recovery path if the row was created by
 * registering through the API first.
 *
 * Pass `{ force: true }` to reset an existing seeded account's password to
 * the configured value — used by `npm run seed -- --force-password`.
 */
export async function seedUsers(
  options: { force?: boolean } = {},
): Promise<void> {
  for (const account of seedAccounts()) {
    const existing = await UserModel.findOne({
      email: account.email.toLowerCase(),
    })
      .select('+passwordHash')
      .exec();

    if (!existing) {
      const passwordHash = await bcrypt.hash(account.password, BCRYPT_ROUNDS);
      const created = await userRepository.create({
        name: account.name,
        email: account.email,
        passwordHash,
        role: account.role,
      });
      await notificationService.create(
        created.id as string,
        'Welcome to Healthify 🌿',
        'Complete your skin profile to unlock personalized ingredient analysis.',
        'welcome',
      );
      logger.info(`Seeded ${account.label}: ${account.email}`);
      continue;
    }

    let changed = false;

    if (existing.role !== account.role) {
      existing.role = account.role;
      changed = true;
      logger.info(`Promoted ${account.email} to ${account.role}`);
    }

    if (options.force) {
      existing.passwordHash = await bcrypt.hash(
        account.password,
        BCRYPT_ROUNDS,
      );
      changed = true;
      logger.info(`Reset password for ${account.email}`);
    } else {
      // A mismatch here is the invisible cause of "the credentials are right
      // but login says invalid", so say so rather than failing silently.
      const matches = await bcrypt.compare(
        account.password,
        existing.passwordHash ?? '',
      );
      if (!matches) {
        logger.warn(
          `${account.email} exists but its stored password does not match ` +
            'the configured one. Re-run with `npm run seed -- --force-password` ' +
            'to reset it.',
        );
      }
    }

    if (changed) await existing.save();
  }
}

/**
 * Startup hook. Seeding demo credentials into a production database would
 * hand anyone a known admin login, so in production this only runs once
 * both passwords have been overridden via the environment.
 */
export async function seedUsersOnStartup(): Promise<void> {
  if (env.NODE_ENV !== 'production') {
    await seedUsers();
    return;
  }

  const usingDefaults = seedAccounts().some((a) => a.usesDefaultPassword);
  if (usingDefaults) {
    logger.warn(
      'Skipping account seeding in production: ADMIN_PASSWORD/DEMO_PASSWORD ' +
        'are still the demo defaults. Set them in the environment and run ' +
        '`npm run seed` to create the accounts.',
    );
    return;
  }
  await seedUsers();
}
