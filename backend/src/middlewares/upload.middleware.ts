import multer from 'multer';

import { ApiError } from '../utils/api-error';

const ALLOWED_MIME_TYPES = new Set([
  'image/jpeg',
  'image/png',
  'image/webp',
  'image/heic',
]);

/**
 * In-memory image upload used by the OCR/analysis endpoints — files are
 * processed and discarded, never written to local disk.
 */
export const imageUpload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 8 * 1024 * 1024 },
  fileFilter: (_req, file, callback) => {
    if (!ALLOWED_MIME_TYPES.has(file.mimetype)) {
      callback(
        ApiError.badRequest(
          'Unsupported file type. Upload a JPEG, PNG, WEBP, or HEIC image.',
        ),
      );
      return;
    }
    callback(null, true);
  },
});
