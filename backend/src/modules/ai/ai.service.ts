import { env } from '../../config/env';
import { logger } from '../../config/logger';
import { ScoreResult } from '../analysis/scoring.service';
import { SkinProfile } from '../users/user.model';

interface AnthropicResponse {
  content?: Array<{ type: string; text?: string }>;
}

const ANTHROPIC_URL = 'https://api.anthropic.com/v1/messages';
const MODEL = 'claude-haiku-4-5';

/**
 * AI layer with graceful degradation: when AI_API_KEY is configured the
 * explanation/chat runs on Claude; otherwise a deterministic, data-grounded
 * generator produces the copy so the product works end-to-end offline.
 */
export class AiService {
  private get enabled(): boolean {
    return Boolean(env.AI_API_KEY);
  }

  private async complete(system: string, user: string): Promise<string | null> {
    if (!this.enabled) return null;
    try {
      const response = await fetch(ANTHROPIC_URL, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          'x-api-key': env.AI_API_KEY!,
          'anthropic-version': '2023-06-01',
        },
        body: JSON.stringify({
          model: MODEL,
          max_tokens: 500,
          system,
          messages: [{ role: 'user', content: user }],
        }),
        signal: AbortSignal.timeout(15_000),
      });
      if (!response.ok) {
        logger.warn(`AI request failed with status ${response.status}`);
        return null;
      }
      const data = (await response.json()) as AnthropicResponse;
      const text = data.content?.find((c) => c.type === 'text')?.text;
      return text?.trim() ?? null;
    } catch (error) {
      logger.warn(`AI request error: ${(error as Error).message}`);
      return null;
    }
  }

  async explainAnalysis(input: {
    productName: string;
    result: ScoreResult;
    profile: SkinProfile | null | undefined;
  }): Promise<string> {
    const { productName, result, profile } = input;

    const aiText = await this.complete(
      'You are a cosmetic chemist writing for a skincare app. Explain the ' +
        'product analysis in 3-5 friendly sentences. Base your answer ONLY ' +
        'on the provided data. No medical claims. Do not use markdown.',
      JSON.stringify({
        productName,
        score: result.score,
        verdict: result.verdict,
        skinType: profile?.skinType,
        concerns: profile?.concerns,
        goodIngredients: result.positives,
        concerningIngredients: result.negatives,
        warnings: result.warnings,
      }),
    );
    if (aiText) return aiText;

    // Deterministic fallback, grounded in the same scoring data.
    const sentences: string[] = [];
    sentences.push(
      result.verdict === 'excellent' || result.verdict === 'good'
        ? `${productName} looks like a ${result.verdict} match with a score of ${result.score}/100.`
        : `${productName} scored ${result.score}/100, which makes it an ${result.verdict} match for you.`,
    );
    if (result.positives.length > 0) {
      sentences.push(
        `On the plus side, ${result.positives.slice(0, 2).join(', and ')}.`,
      );
    }
    if (result.warnings.length > 0) {
      sentences.push(`Worth watching: ${result.warnings[0]}`);
    } else if (result.negatives.length > 0) {
      sentences.push(`Keep an eye on ${result.negatives[0]}.`);
    }
    if (profile?.skinType != null) {
      sentences.push(
        `This assessment is personalized to your ${profile.skinType} skin${
          (profile.concerns?.length ?? 0) > 0
            ? ` and your focus on ${profile.concerns!
                .slice(0, 2)
                .map((c) => c.replace('_', ' '))
                .join(' and ')}`
            : ''
        }.`,
      );
    }
    return sentences.join(' ');
  }

  async chat(input: {
    message: string;
    context?: string;
    fallback: () => Promise<string>;
  }): Promise<string> {
    const aiText = await this.complete(
      'You are Healthify’s skincare assistant. Answer briefly and warmly ' +
        '(2-5 sentences), grounded in cosmetic science. If analysis context ' +
        'is provided, use it. No medical diagnoses. Do not use markdown.',
      input.context
        ? `Context:\n${input.context}\n\nQuestion: ${input.message}`
        : input.message,
    );
    return aiText ?? input.fallback();
  }
}

export const aiService = new AiService();
