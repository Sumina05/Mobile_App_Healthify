import { randomUUID } from 'crypto';
import fs from 'fs';
import path from 'path';

import { NextFunction, Request, RequestHandler, Response } from 'express';
import multer from 'multer';

import { ApiError } from '../utils/api-error';

/**
 * Disk-backed image upload, ported from the Healthify web backend
 * (`Healthify_Web_Backend/src/middlewares/diskUpload.ts`) so both services
 * store and serve uploads identically.
 *
 * This is separate from `imageUpload`, which keeps OCR frames in memory and
 * discards them — avatars have to outlive the request.
 */

/** Uploads live under <repo>/healthify_backend/uploads/<subfolder>/. */
export const UPLOADS_ROOT = path.join(__dirname, '../../uploads');

const ALLOWED_EXTENSIONS = new Set(['.jpg', '.jpeg', '.png', '.webp']);

export function createDiskUpload(subfolder: string): RequestHandler {
  const destination = path.join(UPLOADS_ROOT, subfolder);

  const storage = multer.diskStorage({
    destination: (_req, _file, callback) => {
      fs.mkdirSync(destination, { recursive: true });
      callback(null, destination);
    },
    filename: (_req, file, callback) => {
      const ext = path.extname(file.originalname).toLowerCase();
      // Random name, never the client's — an attacker-chosen filename is a
      // path-traversal risk and leaks nothing useful anyway.
      callback(null, `${randomUUID()}${ALLOWED_EXTENSIONS.has(ext) ? ext : '.jpg'}`);
    },
  });

  return multer({
    storage,
    limits: { fileSize: 5 * 1024 * 1024 },
    fileFilter: (_req, file, callback) => {
      const ext = path.extname(file.originalname).toLowerCase();
      if (file.mimetype.startsWith('image/') && ALLOWED_EXTENSIONS.has(ext)) {
        callback(null, true);
        return;
      }
      callback(ApiError.badRequest('Only JPG, PNG or WEBP images are accepted'));
    },
  }).single('image');
}

/** Routes Multer failures through the global error handler. */
export function wrapUpload(uploadMiddleware: RequestHandler): RequestHandler {
  return (req: Request, res: Response, next: NextFunction): void => {
    uploadMiddleware(req, res, (error: unknown) => {
      if (error) {
        next(
          error instanceof ApiError
            ? error
            : ApiError.badRequest('Image upload failed'),
        );
        return;
      }
      next();
    });
  };
}

/**
 * Public URL built from the request's own host, so it works on localhost, on
 * a LAN address a phone can reach, and behind a deployed domain — without
 * configuration.
 */
export function publicUploadUrl(
  req: { protocol: string; get: (name: string) => string | undefined },
  subfolder: string,
  filename: string,
): string {
  return `${req.protocol}://${req.get('host')}/uploads/${subfolder}/${filename}`;
}
