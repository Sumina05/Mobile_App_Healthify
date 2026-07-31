import compression from 'compression';
import cookieParser from 'cookie-parser';
import cors from 'cors';
import express, { Express } from 'express';
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import morgan from 'morgan';
import swaggerUi from 'swagger-ui-express';

import { env } from './config/env';
import { httpLogStream } from './config/logger';
import { swaggerSpec } from './config/swagger';
import { UPLOADS_ROOT } from './middlewares/disk-upload.middleware';
import { errorHandler, notFoundHandler } from './middlewares/error.middleware';
import v1Router from './routes/v1';

export function createApp(): Express {
  const app = express();

  app.disable('x-powered-by');
  app.set('trust proxy', 1);

  app.use(helmet());
  app.use(
    cors({
      origin: env.CORS_ORIGIN === '*' ? true : env.CORS_ORIGIN.split(','),
      credentials: true,
    }),
  );
  app.use(compression());
  app.use(express.json({ limit: '2mb' }));
  app.use(express.urlencoded({ extended: true }));
  app.use(cookieParser());

  if (env.NODE_ENV !== 'test') {
    app.use(
      morgan(env.NODE_ENV === 'production' ? 'combined' : 'dev', {
        stream: httpLogStream,
      }),
    );
  }

  app.use(
    '/api',
    rateLimit({
      windowMs: 15 * 60 * 1000,
      limit: 300,
      standardHeaders: 'draft-8',
      legacyHeaders: false,
      message: {
        success: false,
        message: 'Too many requests, please try again later.',
      },
    }),
  );

  // Uploaded avatars. crossOriginResourcePolicy is relaxed because helmet's
  // default blocks the app loading these images from a different origin.
  app.use(
    '/uploads',
    express.static(UPLOADS_ROOT, {
      maxAge: '7d',
      setHeaders: (res) =>
        res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin'),
    }),
  );

  app.use('/api/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
  app.use('/api/v1', v1Router);

  app.use(notFoundHandler);
  app.use(errorHandler);

  return app;
}
