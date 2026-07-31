import mongoose from 'mongoose';

import { analysisService } from '../modules/analysis/analysis.service';
import { ingredientService } from '../modules/ingredients/ingredient.service';
import { seedUsersOnStartup } from '../modules/users/user.seed';
import { env } from './env';
import { logger } from './logger';

/**
 * Connects to MongoDB. In production a failed connection is fatal; in
 * development the API stays up (health endpoint reports the DB state) so
 * frontend work is never blocked by a missing local database.
 */
export async function connectDatabase(): Promise<boolean> {
  try {
    await mongoose.connect(env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000,
    });
    logger.info(`MongoDB connected: ${mongoose.connection.name}`);
    await ingredientService.seedIfEmpty();
    await analysisService.seedProductsIfEmpty();
    await seedUsersOnStartup();
    return true;
  } catch (error) {
    if (env.NODE_ENV === 'production') throw error;
    logger.warn(
      `MongoDB unavailable (${(error as Error).message}). ` +
        'API is running without persistence — start MongoDB or set MONGODB_URI to an Atlas cluster.',
    );
    return false;
  }
}

export async function disconnectDatabase(): Promise<void> {
  await mongoose.disconnect();
}

export function isDatabaseConnected(): boolean {
  return mongoose.connection.readyState === 1;
}
