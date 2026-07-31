import { describe, expect, it } from 'vitest';

import {
  buildRecommendationReason,
  matchIngredients,
  scoreProduct,
} from '../src/modules/analysis/scoring.service';

type Catalog = Parameters<typeof matchIngredients>[1];

const catalog = [
  {
    id: 'i-niacinamide',
    name: 'Niacinamide',
    aliases: ['Vitamin B3'],
    safetyRating: 'safe',
    goodForSkinTypes: ['oily', 'sensitive'],
    cautionForSkinTypes: [],
    concernsTargeted: ['acne', 'pores'],
    isCommonAllergen: false,
  },
  {
    id: 'i-fragrance',
    name: 'Fragrance',
    aliases: ['Parfum'],
    safetyRating: 'caution',
    goodForSkinTypes: [],
    cautionForSkinTypes: ['sensitive', 'dry'],
    concernsTargeted: [],
    isCommonAllergen: true,
  },
  {
    id: 'i-sls',
    name: 'Sodium Lauryl Sulfate',
    aliases: ['SLS'],
    safetyRating: 'avoid',
    goodForSkinTypes: [],
    cautionForSkinTypes: ['sensitive', 'dry', 'oily'],
    concernsTargeted: [],
    isCommonAllergen: true,
  },
] as unknown as Catalog;

const oilyAcneProfile = {
  skinType: 'oily',
  concerns: ['acne'],
  allergies: ['Parfum'],
  avoidIngredients: [],
  preferredIngredients: [],
  goals: [],
} as never;

describe('matchIngredients', () => {
  it('matches by name, alias, and strips parentheticals', () => {
    const matches = matchIngredients(
      ['niacinamide', 'Vitamin B3', 'Niacinamide (Vitamin B3)', 'Mystery'],
      catalog,
    );
    expect(matches.get('niacinamide')?.id).toBe('i-niacinamide');
    expect(matches.get('Vitamin B3')?.id).toBe('i-niacinamide');
    expect(matches.get('Niacinamide (Vitamin B3)')?.id).toBe('i-niacinamide');
    expect(matches.get('Mystery')).toBeNull();
  });
});

describe('scoreProduct', () => {
  it('flags declared allergens (via alias) with a heavy penalty', () => {
    const result = scoreProduct(
      matchIngredients(['Fragrance'], catalog),
      oilyAcneProfile,
    );
    const entry = result.breakdown[0]!;
    expect(entry.status).toBe('allergy');
    expect(result.warnings[0]).toContain('allergy');
    expect(result.score).toBeLessThan(70);
    expect(result.safetyRating).toBe('high_risk');
  });

  it('rewards concern-targeting actives that suit the skin type', () => {
    const result = scoreProduct(
      matchIngredients(['Niacinamide'], catalog),
      oilyAcneProfile,
    );
    expect(result.breakdown[0]!.status).toBe('good');
    expect(result.breakdown[0]!.reason).toContain('acne');
    expect(result.score).toBeGreaterThan(70);
    expect(result.goodCount).toBe(1);
  });

  it('warns about irritants for the user skin type', () => {
    const sensitiveProfile = {
      ...(oilyAcneProfile as object),
      skinType: 'sensitive',
      allergies: [],
    } as never;
    const result = scoreProduct(
      matchIngredients(['Sodium Lauryl Sulfate'], catalog),
      sensitiveProfile,
    );
    expect(result.breakdown[0]!.status).toBe('avoid');
    expect(
      result.warnings.some((w) => w.includes('sensitive')),
    ).toBe(true);
    expect(result.watchCount).toBe(1);
  });

  it('treats unknown ingredients as neutral and keeps score bounded', () => {
    const result = scoreProduct(
      matchIngredients(['Totally Unknown Compound'], catalog),
      null,
    );
    expect(result.breakdown[0]!.matched).toBe(false);
    expect(result.score).toBe(70);
    expect(result.verdict).toBe('good');
  });

  it('produces a grounded recommendation reason', () => {
    const result = scoreProduct(
      matchIngredients(['Niacinamide', 'Fragrance'], catalog),
      oilyAcneProfile,
    );
    const reason = buildRecommendationReason(result, oilyAcneProfile);
    expect(reason).toContain('oily');
    expect(reason.toLowerCase()).toContain('niacinamide');
  });
});
