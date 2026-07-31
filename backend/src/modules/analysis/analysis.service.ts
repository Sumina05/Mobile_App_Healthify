import { logger } from '../../config/logger';
import { ApiError } from '../../utils/api-error';
import { aiService } from '../ai/ai.service';
import { IngredientModel } from '../ingredients/ingredient.model';
import { ProductModel } from '../products/product.model';
import { PRODUCT_SEED } from '../products/product.seed';
import { SkinProfile } from '../users/user.model';
import { userRepository } from '../users/user.repository';
import { AnalysisModel } from './analysis.model';
import {
  buildRecommendationReason,
  matchIngredients,
  scoreProduct,
} from './scoring.service';

export interface AnalyzeInput {
  productName?: string;
  brand?: string;
  rawText?: string;
  ingredients: string[];
}

export class AnalysisService {
  async seedProductsIfEmpty(): Promise<void> {
    const count = await ProductModel.estimatedDocumentCount().exec();
    if (count > 0) return;
    await ProductModel.insertMany(PRODUCT_SEED);
    logger.info(`Seeded ${PRODUCT_SEED.length} catalog products`);
  }

  /** The end-to-end pipeline: match → score → alternatives → AI → save. */
  async analyze(userId: string, input: AnalyzeInput) {
    const user = await userRepository.findById(userId);
    if (!user) throw ApiError.notFound('User not found');
    const profile = user.skinProfile;

    const catalog = await IngredientModel.find().exec();
    const catalogDocs = catalog.map((doc) => ({
      ...doc.toObject(),
      id: doc.id as string,
    }));

    const matches = matchIngredients(input.ingredients, catalogDocs);
    const result = scoreProduct(matches, profile);
    const recommendationReason = buildRecommendationReason(result, profile);

    const productName = input.productName?.trim() || 'Scanned product';
    const [aiExplanation, alternatives] = await Promise.all([
      aiService.explainAnalysis({ productName, result, profile }),
      this.findAlternatives(profile, result.score, productName, catalogDocs),
    ]);

    const summary =
      `${result.goodCount} beneficial, ${result.watchCount} to watch, ` +
      `${result.warnings.length} warning${result.warnings.length === 1 ? '' : 's'} ` +
      `across ${input.ingredients.length} ingredients.`;

    return AnalysisModel.create({
      userId,
      productName,
      brand: input.brand?.trim() || null,
      rawText: input.rawText ?? '',
      ingredientNames: input.ingredients,
      score: result.score,
      verdict: result.verdict,
      safetyRating: result.safetyRating,
      summary,
      recommendationReason,
      aiExplanation,
      warnings: result.warnings,
      breakdown: result.breakdown,
      alternatives,
      goodCount: result.goodCount,
      watchCount: result.watchCount,
      matchedCount: result.matchedCount,
    });
  }

  /** Scores catalog products against the same profile; returns the top 3. */
  private async findAlternatives(
    profile: SkinProfile | null | undefined,
    analyzedScore: number,
    analyzedName: string,
    catalogDocs: Parameters<typeof matchIngredients>[1],
  ) {
    const products = await ProductModel.find().exec();
    return products
      .filter(
        (p) => p.name.toLowerCase() !== analyzedName.toLowerCase(),
      )
      .map((product) => {
        const productResult = scoreProduct(
          matchIngredients([...product.ingredientNames], catalogDocs),
          profile,
        );
        return {
          productId: product.id as string,
          name: product.name,
          brand: product.brand,
          category: product.category,
          matchPercent: productResult.score,
        };
      })
      .filter((alt) => alt.matchPercent > Math.min(analyzedScore, 84))
      .sort((a, b) => b.matchPercent - a.matchPercent)
      .slice(0, 3);
  }

  async getById(userId: string, analysisId: string) {
    const analysis = await AnalysisModel.findOne({
      _id: analysisId,
      userId,
    }).exec();
    if (!analysis) throw ApiError.notFound('Analysis not found');
    return analysis;
  }

  async toggleFavorite(userId: string, analysisId: string) {
    const analysis = await this.getById(userId, analysisId);
    analysis.favorite = !analysis.favorite;
    await analysis.save();
    return analysis;
  }

  async compare(userId: string, idA: string, idB: string) {
    if (idA === idB) {
      throw ApiError.badRequest('Choose two different analyses to compare');
    }
    const [a, b] = await Promise.all([
      this.getById(userId, idA),
      this.getById(userId, idB),
    ]);

    const winner =
      a.score === b.score ? null : a.score > b.score ? a.id : b.id;
    return {
      a,
      b,
      winner,
      deltas: {
        score: a.score - b.score,
        goodCount: a.goodCount - b.goodCount,
        watchCount: a.watchCount - b.watchCount,
        warnings: a.warnings.length - b.warnings.length,
      },
    };
  }
}

export const analysisService = new AnalysisService();
