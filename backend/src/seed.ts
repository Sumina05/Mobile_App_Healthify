import { connectDatabase, disconnectDatabase } from './config/db';
import { logger } from './config/logger';
import { analysisService } from './modules/analysis/analysis.service';
import { ingredientService } from './modules/ingredients/ingredient.service';
import { seedUsers } from './modules/users/user.seed';

/**
 * Seeds everything a fresh database needs: ingredients, catalog products,
 * and the admin + demo accounts. Idempotent — safe to re-run.
 *
 *   npm run seed
 *   npm run seed -- --force-password   # also reset seeded account passwords
 */
async function main(): Promise<void> {
  const force = process.argv.includes('--force-password');

  // connectDatabase already seeds ingredients and products; calling them
  // again is harmless because both are no-ops on a populated collection.
  const connected = await connectDatabase();
  if (!connected) {
    logger.error('Could not connect to MongoDB — nothing was seeded.');
    process.exitCode = 1;
    return;
  }

  await ingredientService.seedIfEmpty();
  await analysisService.seedProductsIfEmpty();
  await seedUsers({ force });

  logger.info('Seeding complete.');
}

main()
  .catch((error: unknown) => {
    logger.error(`Seeding failed: ${(error as Error).message}`);
    process.exitCode = 1;
  })
  .finally(() => disconnectDatabase());
