import { logger } from '../../config/logger';
import { SkinProfile } from '../users/user.model';
import { IngredientModel } from './ingredient.model';
import { INGREDIENT_SEED } from './ingredient.seed';

export class IngredientService {
  /** Idempotent seed used on startup so a fresh DB is instantly useful. */
  async seedIfEmpty(): Promise<void> {
    const count = await IngredientModel.estimatedDocumentCount().exec();
    if (count > 0) return;
    await IngredientModel.insertMany(INGREDIENT_SEED);
    logger.info(`Seeded ${INGREDIENT_SEED.length} ingredients`);
  }

  async search(query?: string, limit = 30) {
    if (query && query.trim().length > 0) {
      const pattern = new RegExp(
        query.trim().replace(/[.*+?^${}()|[\]\\]/g, '\\$&'),
        'i',
      );
      return IngredientModel.find({
        $or: [{ name: pattern }, { aliases: pattern }],
      })
        .limit(limit)
        .exec();
    }
    return IngredientModel.find().sort({ name: 1 }).limit(limit).exec();
  }

  async getById(id: string) {
    return IngredientModel.findById(id).exec();
  }

  /** Deterministic "ingredient of the day" — same pick for everyone all day. */
  async ingredientOfTheDay() {
    const all = await IngredientModel.find().sort({ name: 1 }).exec();
    if (all.length === 0) return null;
    const dayNumber = Math.floor(Date.now() / 86_400_000);
    return all[dayNumber % all.length] ?? null;
  }

  /**
   * Recommendation engine v1: ranks ingredients for a skin profile.
   * +2 per targeted concern match, +1 for skin-type fit, hard-excludes
   * declared allergens/avoided ingredients and skin-type cautions.
   */
  async recommendedFor(profile: SkinProfile | null | undefined, limit = 6) {
    const all = await IngredientModel.find({
      safetyRating: { $ne: 'avoid' },
    }).exec();
    if (!profile) {
      return all.filter((i) => i.safetyRating === 'safe').slice(0, limit);
    }

    const avoidSet = new Set(
      [...(profile.allergies ?? []), ...(profile.avoidIngredients ?? [])].map(
        (a) => a.toLowerCase(),
      ),
    );
    const concerns = new Set<string>(profile.concerns ?? []);

    const scored = all
      .filter((ingredient) => {
        const names = [ingredient.name, ...ingredient.aliases].map((n) =>
          n.toLowerCase(),
        );
        if (names.some((n) => avoidSet.has(n))) return false;
        if (ingredient.cautionForSkinTypes.includes(profile.skinType)) {
          return false;
        }
        if (ingredient.isCommonAllergen && profile.skinType === 'sensitive') {
          return false;
        }
        return true;
      })
      .map((ingredient) => {
        let score = 0;
        for (const concern of ingredient.concernsTargeted) {
          if (concerns.has(concern)) score += 2;
        }
        if (ingredient.goodForSkinTypes.includes(profile.skinType)) score += 1;
        return { ingredient, score };
      })
      .filter((entry) => entry.score > 0)
      .sort((a, b) => b.score - a.score);

    return scored.slice(0, limit).map((entry) => entry.ingredient);
  }
}

export const ingredientService = new IngredientService();
