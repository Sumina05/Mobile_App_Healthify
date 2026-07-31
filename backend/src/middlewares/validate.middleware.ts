import { RequestHandler } from 'express';
import { ZodType } from 'zod';

interface ValidationSchemas {
  body?: ZodType;
  query?: ZodType;
  params?: ZodType;
}

/**
 * Parses request parts against Zod schemas. The parsed (and coerced) body
 * replaces req.body; query/params results land on res.locals because
 * Express 5 exposes them as read-only getters. ZodErrors propagate to the
 * central error handler, which renders a 422 with per-field messages.
 */
export function validate(schemas: ValidationSchemas): RequestHandler {
  return (req, res, next) => {
    if (schemas.body) {
      req.body = schemas.body.parse(req.body);
    }
    if (schemas.query) {
      res.locals.query = schemas.query.parse(req.query);
    }
    if (schemas.params) {
      res.locals.params = schemas.params.parse(req.params);
    }
    next();
  };
}
