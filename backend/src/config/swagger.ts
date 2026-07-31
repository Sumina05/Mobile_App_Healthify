import path from 'path';

import swaggerJsdoc from 'swagger-jsdoc';

import { env } from './env';

/** OpenAPI spec assembled from JSDoc annotations in module route files. */
export const swaggerSpec = swaggerJsdoc({
  definition: {
    openapi: '3.0.3',
    info: {
      title: 'Healthify API',
      version: '0.1.0',
      description:
        'AI-powered skincare & cosmetic ingredient analysis platform. ' +
        'All endpoints are versioned under /api/v1.',
    },
    servers: [
      { url: `http://localhost:${env.PORT}/api/v1`, description: 'Local' },
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT',
        },
      },
    },
  },
  // Globs require forward slashes — path.join would emit backslashes on
  // Windows and silently match nothing.
  apis: ['ts', 'js'].map((ext) =>
    path
      .join(__dirname, `../modules/**/*.routes.${ext}`)
      .replace(/\\/g, '/'),
  ),
});
