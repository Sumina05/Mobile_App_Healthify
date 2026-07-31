import { HydratedDocument, InferSchemaType, Schema, model } from 'mongoose';

export const SKIN_TYPES = [
  'oily',
  'dry',
  'combination',
  'sensitive',
  'normal',
] as const;

export const SKIN_CONCERNS = [
  'acne',
  'dark_spots',
  'dullness',
  'redness',
  'aging',
  'oiliness',
  'dryness',
  'texture',
  'pores',
] as const;

export const GENDERS = ['female', 'male', 'other', 'prefer_not_to_say'] as const;

const skinProfileSchema = new Schema(
  {
    age: { type: Number, min: 13, max: 120 },
    gender: { type: String, enum: GENDERS },
    skinType: { type: String, enum: SKIN_TYPES, required: true },
    concerns: { type: [String], enum: SKIN_CONCERNS, default: [] },
    allergies: { type: [String], default: [] },
    preferredIngredients: { type: [String], default: [] },
    avoidIngredients: { type: [String], default: [] },
    goals: { type: [String], default: [] },
    completedAt: { type: Date, default: Date.now },
  },
  { _id: false },
);

const premiumSchema = new Schema(
  {
    plan: { type: String, enum: ['monthly', 'yearly'], required: true },
    activatedAt: { type: Date, required: true },
    expiresAt: { type: Date, required: true },
  },
  { _id: false },
);

const passwordResetSchema = new Schema(
  {
    codeHash: { type: String, required: true },
    expiresAt: { type: Date, required: true },
  },
  { _id: false },
);

const userSchema = new Schema(
  {
    name: { type: String, required: true, trim: true, minlength: 2 },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    // Absent for Google-only accounts — see loginWithGoogle in auth.service.ts.
    passwordHash: { type: String, select: false },
    provider: { type: String, enum: ['local', 'google'], default: 'local' },
    // Sparse: only Google-linked accounts have this, and it must stay unique
    // among those that do.
    // No `default: null` — a sparse unique index only excludes fields that
    // are absent, and Mongoose would otherwise write an explicit `null` for
    // every local account, colliding on that shared null value.
    googleId: { type: String, index: { unique: true, sparse: true } },
    role: { type: String, enum: ['user', 'admin'], default: 'user' },
    avatarUrl: { type: String, default: null },
    skinProfile: { type: skinProfileSchema, default: null },
    premium: { type: premiumSchema, default: null },
    passwordReset: { type: passwordResetSchema, default: null, select: false },
  },
  { timestamps: true },
);

userSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    delete ret.passwordHash;
    delete ret.passwordReset;
    return ret;
  },
});

export type SkinProfile = InferSchemaType<typeof skinProfileSchema>;
export type User = InferSchemaType<typeof userSchema>;
export type UserDocument = HydratedDocument<User>;

export const UserModel = model('User', userSchema);
