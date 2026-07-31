import { env } from '../../config/env';
import { logger } from '../../config/logger';

/**
 * Full catalogue detail, in the flat shape both the barcode lookup and the
 * slug lookup return — the web API's `getByBarcode` and `getBySlug` produce
 * the identical `ProductDetailDto`, so one mapper ({@link mapWebProductDetail})
 * serves both instead of each endpoint maintaining its own partial view.
 * [ingredientNames] is deliberately the same shape the OCR scan produces, so
 * a barcode hit, a catalogue browse, and a label scan all converge on the
 * same `POST /analysis` call.
 */
export interface ProductDetail {
  id: string;
  /** Empty for a product with no catalogue record (Open Facts barcode hit) —
   * such a product cannot be looked up again, only used as already-fetched. */
  slug: string;
  name: string;
  brand: string;
  category: string;
  description: string;
  imageUrl: string | null;
  ingredientNames: string[];
  /** Null wherever the source has no curated safety data (Open Facts). */
  safetyScore: number | null;
  safetyBand: string | null;
  suitableSkinTypes: string[];
  /** Deduped union of every ingredient's own benefits/side effects — the
   * catalogue has no product-level fields for these. */
  benefits: string[];
  sideEffects: string[];
}

export interface BarcodeProduct extends ProductDetail {
  barcode: string;
  /** 'catalog' = the curated Healthify catalogue; 'external' = Open Facts. */
  source: 'catalog' | 'external';
}

const REQUEST_TIMEOUT_MS = 8000;

/** Shape of the web API's success envelope. */
interface WebEnvelope<T> {
  success: boolean;
  message: string;
  data: T;
}

/** Matches web's `ProductDetailDto` (`getByBarcode` and `getBySlug` both
 * return this exact shape) — only the fields this service actually reads. */
interface WebProductDetail {
  id?: string;
  slug?: string;
  name?: string;
  barcode?: string;
  description?: string;
  imageUrl?: string;
  safetyScore?: number;
  safetyBand?: string;
  suitableSkinTypes?: string[];
  brand?: { name?: string } | string;
  category?: { name?: string } | string;
  ingredients?: {
    position?: number | null;
    ingredient?: {
      inciName?: string;
      benefits?: string[];
      sideEffects?: string[];
    };
  }[];
}

interface WebExternalProduct {
  name?: string;
  brand?: string;
  imageUrl?: string;
  ingredientsText?: string;
}

function refName(value: { name?: string } | string | undefined): string {
  if (typeof value === 'string') return value;
  return value?.name ?? 'Unknown';
}

/** The one place a web `ProductDetailDto` becomes this API's flat shape. */
function mapWebProductDetail(
  product: WebProductDetail,
  fallbackId: string,
): ProductDetail {
  // INCI order encodes relative concentration, so preserve it.
  const ingredientRefs = (product.ingredients ?? [])
    .slice()
    .sort((a, b) => (a.position ?? 0) - (b.position ?? 0));
  const ingredientNames = ingredientRefs
    .map((ref) => ref.ingredient?.inciName)
    .filter((name): name is string => Boolean(name));
  const benefits = [
    ...new Set(ingredientRefs.flatMap((ref) => ref.ingredient?.benefits ?? [])),
  ];
  const sideEffects = [
    ...new Set(
      ingredientRefs.flatMap((ref) => ref.ingredient?.sideEffects ?? []),
    ),
  ];

  return {
    id: product.id ?? fallbackId,
    slug: product.slug ?? '',
    name: product.name ?? `Product ${fallbackId}`,
    brand: refName(product.brand),
    category: refName(product.category),
    description: product.description ?? '',
    imageUrl: product.imageUrl ?? null,
    ingredientNames,
    safetyScore: product.safetyScore ?? null,
    safetyBand: product.safetyBand ?? null,
    suitableSkinTypes: product.suitableSkinTypes ?? [],
    benefits,
    sideEffects,
  };
}

/**
 * Barcode lookups against the web API, which is the single source of truth
 * for the product catalogue. This service owns no product data of its own —
 * it maps the web response into the flat shape this API already uses.
 */
export class BarcodeService {
  /** Returns null when the code is unknown to both the catalogue and Open Facts. */
  async lookup(code: string): Promise<BarcodeProduct | null> {
    const fromCatalog = await this.fromCatalog(code);
    if (fromCatalog) return fromCatalog;
    return this.fromExternal(code);
  }

  private async fromCatalog(code: string): Promise<BarcodeProduct | null> {
    const body = await this.get<WebEnvelope<{ product: WebProductDetail }>>(
      `/products/barcode/${encodeURIComponent(code)}`,
    );
    const product = body?.data?.product;
    if (!product) return null;

    return {
      ...mapWebProductDetail(product, code),
      barcode: product.barcode ?? code,
      source: 'catalog',
    };
  }

  private async fromExternal(code: string): Promise<BarcodeProduct | null> {
    const body = await this.get<
      WebEnvelope<{ external: WebExternalProduct | null }>
    >(`/products/barcode/${encodeURIComponent(code)}/external`);
    const external = body?.data?.external;
    if (!external) return null;

    return {
      id: code,
      slug: '', // Not a catalogue record — nothing to re-fetch by slug later.
      barcode: code,
      name: external.name ?? `Barcode ${code}`,
      brand: external.brand ?? 'Unknown',
      category: 'Uncategorized',
      description: '',
      imageUrl: external.imageUrl ?? null,
      ingredientNames: parseIngredientsText(external.ingredientsText ?? ''),
      safetyScore: null,
      safetyBand: null,
      suitableSkinTypes: [],
      benefits: [],
      sideEffects: [],
      source: 'external',
    };
  }

  /**
   * A 404 from the web API is an expected "not in this source" answer, not a
   * failure. Anything else (unreachable, 5xx, malformed) is logged and
   * treated as a miss so a barcode scan degrades to the OCR fallback rather
   * than erroring the whole request.
   */
  private async get<T>(path: string): Promise<T | null> {
    const url = `${env.WEB_API_BASE_URL}${path}`;
    try {
      const response = await fetch(url, {
        headers: { accept: 'application/json' },
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
      if (response.status === 404) return null;
      if (!response.ok) {
        logger.warn(`Barcode lookup failed: ${response.status} for ${url}`);
        return null;
      }
      return (await response.json()) as T;
    } catch (error) {
      logger.warn(
        `Barcode lookup could not reach the web API at ${url}: ` +
          `${(error as Error).message}`,
      );
      return null;
    }
  }
}

/**
 * Splits a free-text INCI list (Open Facts stores one string) using the same
 * separators and noise filtering the OCR parser applies.
 */
export function parseIngredientsText(text: string): string[] {
  return text
    .replace(/\n/g, ' ')
    .replace(/^\s*ingredients?\s*[:：]/i, '')
    .split(/[,;•·|]/)
    .map((token) => token.trim().replace(/\.$/, ''))
    .filter((token) => token.length >= 3 && token.length <= 80)
    .filter((token) => /[A-Za-z]/.test(token));
}

export const barcodeService = new BarcodeService();

/**
 * One page of catalogue results in this API's flat shape. `ingredientNames`
 * is deliberately absent here: the web list endpoint returns only a count,
 * never the INCI list, so a list item is a summary — {@link CatalogService.detail}
 * fetches the rest once a specific product is opened.
 */
export interface CatalogPage {
  items: {
    id: string;
    slug: string;
    name: string;
    brand: string;
    category: string;
  }[];
  categories: string[];
  page: number;
  pageSize: number;
  total: number;
  totalPages: number;
}

interface WebListItem {
  id?: string;
  slug?: string;
  name?: string;
  brand?: { name?: string } | string;
  category?: { name?: string } | string;
}

/**
 * Product browsing, proxied to the web API for the same reason barcode lookup
 * is: the web catalogue is the single source of truth. This service keeps no
 * product data of its own, so the two apps cannot drift apart — previously
 * this API served a 10-product starter seed while the web app had 39, which
 * made whole categories look empty on mobile.
 */
export class CatalogService {
  /** The web API filters by category *slug*; clients here pass the name. */
  private toSlug(value: string): string {
    return value.trim().toLowerCase().replace(/\s+/g, '-');
  }

  async list(options: {
    search?: string;
    category?: string;
    page?: number;
    pageSize?: number;
  }): Promise<CatalogPage> {
    const page = options.page ?? 1;
    const pageSize = Math.min(options.pageSize ?? 20, 48); // web caps limit at 48
    const params = new URLSearchParams({
      page: String(page),
      limit: String(pageSize),
    });
    if (options.search) params.set('search', options.search);
    if (options.category) params.set('category', this.toSlug(options.category));

    const [listBody, categories] = await Promise.all([
      this.get<{ data?: { items?: WebListItem[]; total?: number } }>(
        `/products?${params.toString()}`,
      ),
      this.categories(),
    ]);

    const items = (listBody?.data?.items ?? []).map((item) => ({
      id: String(item.id ?? ''),
      slug: item.slug ?? '',
      name: item.name ?? 'Unknown product',
      brand: refName(item.brand),
      category: refName(item.category),
    }));
    const total = listBody?.data?.total ?? items.length;

    return {
      items,
      categories,
      page,
      pageSize,
      total,
      totalPages: Math.max(1, Math.ceil(total / pageSize)),
    };
  }

  /** Facet list, so the filter bar offers every category the catalogue has. */
  async categories(): Promise<string[]> {
    const body = await this.get<{
      data?: { categories?: { name?: string }[] };
    }>('/products/filters');
    return (body?.data?.categories ?? [])
      .map((c) => c.name)
      .filter((name): name is string => Boolean(name));
  }

  /**
   * Full detail for one product, fetched when it's opened — this is what a
   * list item's summary was missing (ingredients, description, safety band,
   * skin suitability, benefits/side effects).
   */
  async detail(slug: string): Promise<ProductDetail | null> {
    const body = await this.get<WebEnvelope<{ product: WebProductDetail }>>(
      `/products/${encodeURIComponent(slug)}`,
    );
    const product = body?.data?.product;
    if (!product) return null;
    return mapWebProductDetail(product, slug);
  }

  private async get<T>(path: string): Promise<T | null> {
    const url = `${env.WEB_API_BASE_URL}${path}`;
    try {
      const response = await fetch(url, {
        headers: { accept: 'application/json' },
        signal: AbortSignal.timeout(REQUEST_TIMEOUT_MS),
      });
      if (!response.ok) {
        logger.warn(`Catalogue request failed: ${response.status} for ${url}`);
        return null;
      }
      return (await response.json()) as T;
    } catch (error) {
      logger.warn(
        `Catalogue request could not reach the web API at ${url}: ` +
          `${(error as Error).message}`,
      );
      return null;
    }
  }
}

export const catalogService = new CatalogService();
