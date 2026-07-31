import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const DEV_ONLY_SECRET = 'healthify-dev-secret-change-me-0123456789abcdef';

/** Demo credentials. Publicly known, so production seeding refuses them. */
export const DEFAULT_ADMIN_PASSWORD = 'Admin12345';
export const DEFAULT_DEMO_PASSWORD = 'User12345';

const envSchema = z
  .object({
    NODE_ENV: z
      .enum(['development', 'test', 'production'])
      .default('development'),
    PORT: z.coerce.number().int().positive().default(5000),
    /**
     * Bind address. 0.0.0.0 listens on every interface, which is what lets a
     * phone on the same Wi-Fi reach the API. Set to 127.0.0.1 to restrict the
     * server to this machine.
     */
    HOST: z.string().default('0.0.0.0'),
    MONGODB_URI: z
      .string()
      .default('mongodb://127.0.0.1:27017/healthify'),
    JWT_ACCESS_SECRET: z.string().min(32).default(DEV_ONLY_SECRET),
    JWT_REFRESH_SECRET: z.string().min(32).default(DEV_ONLY_SECRET),
    JWT_ACCESS_EXPIRES: z.string().default('15m'),
    JWT_REFRESH_EXPIRES: z.string().default('30d'),
    CORS_ORIGIN: z.string().default('*'),
    AI_API_KEY: z.string().optional(),
    // Google Sign-In. Same client id as the web app (an OAuth client id is
    // not a secret) so both apps' `google-auth-library` verification and the
    // Flutter app's native Google Sign-In share one Google Cloud project.
    // Leave empty to disable — /auth/google then returns a clear
    // "not configured" error and the client hides the Google button.
    GOOGLE_CLIENT_ID: z.string().optional().or(z.literal('')),
    /**
     * Base URL of the Healthify **web** API, which owns the product catalogue
     * and its EAN/UPC barcodes. Barcode lookups proxy there rather than
     * duplicating the catalogue into this service's database.
     */
    WEB_API_BASE_URL: z.string().default('http://localhost:5001/api/v1'),
    // Seeded accounts. Defaults are demo credentials and are intentionally
    // NOT auto-seeded in production — see seedAccounts().
    ADMIN_EMAIL: z.email().default('admin@healthify.com'),
    ADMIN_PASSWORD: z.string().min(8).default(DEFAULT_ADMIN_PASSWORD),
    ADMIN_NAME: z.string().default('Healthify Admin'),
    DEMO_EMAIL: z.email().default('thakuri.sumina05@gmail.com'),
    DEMO_PASSWORD: z.string().min(8).default(DEFAULT_DEMO_PASSWORD),
    DEMO_NAME: z.string().default('Sumina Thakuri'),
    // Payment gateways (Nepal). Absent keys → simulated dev checkout.
    /**
     * The Khalti-registered site. Khalti validates `website_url` against the
     * merchant registration and expects `return_url` on the same origin, so
     * this must match the web app's CLIENT_URL — sending a different origin
     * (or a domain that isn't registered) leaves its payment page inert.
     */
    CLIENT_URL: z.string().url().default('http://localhost:3000'),
    // Same names/semantics as the web backend so one merchant account and one
    // set of values serve both apps. `.or(z.literal(''))` mirrors the web
    // schema: an empty value means "not configured" → simulated checkout.
    KHALTI_SECRET_KEY: z.string().optional().or(z.literal('')),
    KHALTI_BASE_URL: z.string().url().default('https://a.khalti.com/api/v2'),
    ESEWA_SECRET_KEY: z.string().optional(),
    ESEWA_PRODUCT_CODE: z.string().default('EPAYTEST'),
    ESEWA_FORM_URL: z
      .string()
      .default('https://rc-epay.esewa.com.np/api/epay/main/v2/form'),
    PAYMENT_RETURN_URL: z
      .string()
      .default('https://healthify.app/payment/return'),
    /** Externally reachable origin of this API, used to build the eSewa
     * redirect URL that the payer's browser opens. */
    PUBLIC_BASE_URL: z.string().default('http://localhost:5000'),
  })
  .superRefine((config, ctx) => {
    if (config.NODE_ENV === 'production') {
      if (
        config.JWT_ACCESS_SECRET === DEV_ONLY_SECRET ||
        config.JWT_REFRESH_SECRET === DEV_ONLY_SECRET
      ) {
        ctx.addIssue({
          code: 'custom',
          message: 'JWT secrets must be set explicitly in production',
        });
      }
    }
  });

const parsed = envSchema.safeParse(process.env);
if (!parsed.success) {
  // Logger depends on env, so fail loudly with plain console here.
  console.error('Invalid environment configuration:', parsed.error.issues);
  process.exit(1);
}

export const env = parsed.data;
export type Env = typeof env;
