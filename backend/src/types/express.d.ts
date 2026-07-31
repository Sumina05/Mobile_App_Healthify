import { UserRole } from '../utils/jwt';

declare global {
  namespace Express {
    interface Request {
      /** Populated by the auth middleware after JWT verification. */
      user?: { id: string; role: UserRole };
    }
  }
}

export {};
