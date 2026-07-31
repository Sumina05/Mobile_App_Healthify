import { InferSchemaType, Schema, model } from 'mongoose';

/**
 * Whitelist of active refresh tokens (stored as SHA-256 hashes).
 * Rotation deletes the old hash and inserts the replacement; the TTL
 * index purges expired rows automatically.
 */
const refreshTokenSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    tokenHash: { type: String, required: true, unique: true },
    expiresAt: { type: Date, required: true },
  },
  { timestamps: true },
);

refreshTokenSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

export type RefreshToken = InferSchemaType<typeof refreshTokenSchema>;

export const RefreshTokenModel = model('RefreshToken', refreshTokenSchema);
