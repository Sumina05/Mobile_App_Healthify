import { Ingredient } from '../ingredients/ingredient.model';
import { SkinProfile } from '../users/user.model';

export type BreakdownStatus =
  | 'good'
  | 'neutral'
  | 'caution'
  | 'avoid'
  | 'allergy';

export interface BreakdownEntry {
  name: string;
  matched: boolean;
  status: BreakdownStatus;
  reason: string;
  ingredientId?: string;
}

export interface ScoreResult {
  score: number;
  verdict: 'excellent' | 'good' | 'average' | 'poor';
  safetyRating: 'low_risk' | 'moderate_risk' | 'high_risk';
  breakdown: BreakdownEntry[];
  warnings: string[];
  goodCount: number;
  watchCount: number;
  matchedCount: number;
  /** Human-readable factors used to build the recommendation reason. */
  positives: string[];
  negatives: string[];
}

type IngredientDoc = Ingredient & { id: string };

const normalize = (value: string): string =>
  value
    .toLowerCase()
    .replace(/\(.*?\)/g, ' ') // "Niacinamide (Vitamin B3)" → "Niacinamide"
    .replace(/[^a-z0-9\s.-]/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();

/** Maps every scanned name to a database ingredient (exact or alias). */
export function matchIngredients(
  scannedNames: string[],
  catalog: IngredientDoc[],
): Map<string, IngredientDoc | null> {
  const index = new Map<string, IngredientDoc>();
  for (const ingredient of catalog) {
    index.set(normalize(ingredient.name), ingredient);
    for (const alias of ingredient.aliases) {
      index.set(normalize(alias), ingredient);
    }
  }

  const result = new Map<string, IngredientDoc | null>();
  for (const raw of scannedNames) {
    const cleaned = normalize(raw);
    result.set(raw, index.get(cleaned) ?? null);
  }
  return result;
}

/**
 * Deterministic, explainable suitability scoring. Every point moved is
 * captured as a breakdown reason so the UI (and the AI explanation) can
 * show exactly WHY a product got its score.
 */
export function scoreProduct(
  matches: Map<string, IngredientDoc | null>,
  profile: SkinProfile | null | undefined,
): ScoreResult {
  let score = 70;
  const breakdown: BreakdownEntry[] = [];
  const warnings: string[] = [];
  const positives: string[] = [];
  const negatives: string[] = [];
  let goodCount = 0;
  let watchCount = 0;
  let matchedCount = 0;

  const avoidSet = new Set(
    [
      ...(profile?.allergies ?? []),
      ...(profile?.avoidIngredients ?? []),
    ].map(normalize),
  );
  const concerns = new Set<string>(profile?.concerns ?? []);
  const skinType = profile?.skinType;

  for (const [rawName, ingredient] of matches) {
    if (!ingredient) {
      breakdown.push({
        name: rawName,
        matched: false,
        status: 'neutral',
        reason: 'Not in our database yet — treated as neutral.',
      });
      continue;
    }
    matchedCount += 1;

    const names = [ingredient.name, ...ingredient.aliases].map(normalize);
    const isDeclaredAllergen = names.some((n) => avoidSet.has(n));

    if (isDeclaredAllergen) {
      score -= 25;
      watchCount += 1;
      warnings.push(
        `${ingredient.name} matches an allergy or avoided ingredient in your profile.`,
      );
      negatives.push(`contains your listed allergen ${ingredient.name}`);
      breakdown.push({
        name: ingredient.name,
        matched: true,
        status: 'allergy',
        reason: 'You listed this in your allergies / avoid list.',
        ingredientId: ingredient.id,
      });
      continue;
    }

    let delta = 0;
    let status: BreakdownStatus = 'neutral';
    const reasons: string[] = [];

    switch (ingredient.safetyRating) {
      case 'safe':
        delta += 3;
        status = 'good';
        reasons.push('well-tolerated ingredient');
        break;
      case 'caution':
        delta -= 4;
        status = 'caution';
        reasons.push('use with care');
        break;
      case 'avoid':
        delta -= 10;
        status = 'avoid';
        reasons.push('commonly problematic ingredient');
        break;
    }

    if (skinType != null) {
      if (ingredient.cautionForSkinTypes.includes(skinType)) {
        delta -= 6;
        status = status === 'good' ? 'caution' : status;
        reasons.push(`can irritate ${skinType} skin`);
        warnings.push(
          `${ingredient.name} may irritate your ${skinType} skin.`,
        );
        negatives.push(`${ingredient.name} can be harsh on ${skinType} skin`);
      } else if (ingredient.goodForSkinTypes.includes(skinType)) {
        delta += 2;
        reasons.push(`suits ${skinType} skin`);
      }

      if (
        ingredient.isCommonAllergen &&
        skinType === 'sensitive' &&
        status !== 'avoid'
      ) {
        delta -= 4;
        status = 'caution';
        reasons.push('common allergen — sensitive skin risk');
        warnings.push(
          `${ingredient.name} is a common allergen — patch test with sensitive skin.`,
        );
      }
    }

    const targeted = ingredient.concernsTargeted.filter((c) =>
      concerns.has(c),
    );
    if (targeted.length > 0) {
      delta += Math.min(targeted.length * 2, 6);
      reasons.push(
        `targets your ${targeted
          .map((c) => c.replace('_', ' '))
          .join(' and ')}`,
      );
      positives.push(
        `${ingredient.name} targets ${targeted
          .map((c) => c.replace('_', ' '))
          .join(', ')}`,
      );
    } else if (status === 'good') {
      positives.push(`${ingredient.name} supports overall skin health`);
    }

    if (status === 'good') goodCount += 1;
    if (status === 'caution' || status === 'avoid') {
      watchCount += 1;
      if (targeted.length === 0) {
        negatives.push(`${ingredient.name} (${reasons[0] ?? 'watch'})`);
      }
    }

    score += delta;
    breakdown.push({
      name: ingredient.name,
      matched: true,
      status,
      reason: `${reasons.join('; ')}.`,
      ingredientId: ingredient.id,
    });
  }

  score = Math.max(0, Math.min(100, Math.round(score)));
  const hasAllergy = breakdown.some((b) => b.status === 'allergy');

  const verdict =
    score >= 85 ? 'excellent' : score >= 70 ? 'good' : score >= 50 ? 'average' : 'poor';
  const safetyRating = hasAllergy
    ? 'high_risk'
    : watchCount > goodCount
      ? 'moderate_risk'
      : 'low_risk';

  return {
    score,
    verdict,
    safetyRating,
    breakdown,
    warnings,
    goodCount,
    watchCount,
    matchedCount,
    positives,
    negatives,
  };
}

/** One-paragraph, data-grounded reason a user can trust. */
export function buildRecommendationReason(
  result: ScoreResult,
  profile: SkinProfile | null | undefined,
): string {
  const parts: string[] = [];
  if (profile?.skinType != null) {
    parts.push(`Scored for your ${profile.skinType} skin profile.`);
  } else {
    parts.push(
      'Scored with general safety data — complete your skin profile for a personalized score.',
    );
  }
  if (result.positives.length > 0) {
    parts.push(`Works in its favor: ${result.positives.slice(0, 3).join('; ')}.`);
  }
  if (result.negatives.length > 0) {
    parts.push(`Holding it back: ${result.negatives.slice(0, 3).join('; ')}.`);
  }
  if (result.positives.length === 0 && result.negatives.length === 0) {
    parts.push(
      'No standout actives or risks were detected among the recognized ingredients.',
    );
  }
  return parts.join(' ');
}
