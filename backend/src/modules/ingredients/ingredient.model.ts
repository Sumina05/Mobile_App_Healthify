import { InferSchemaType, Schema, model } from 'mongoose';

export const SAFETY_RATINGS = ['safe', 'caution', 'avoid'] as const;

const ingredientSchema = new Schema(
  {
    name: { type: String, required: true, unique: true, trim: true },
    aliases: { type: [String], default: [] },
    tagline: { type: String, required: true },
    purpose: { type: String, required: true },
    description: { type: String, required: true },
    benefits: { type: [String], default: [] },
    sideEffects: { type: [String], default: [] },
    safetyRating: { type: String, enum: SAFETY_RATINGS, required: true },
    goodForSkinTypes: { type: [String], default: [] },
    cautionForSkinTypes: { type: [String], default: [] },
    concernsTargeted: { type: [String], default: [] },
    isCommonAllergen: { type: Boolean, default: false },
  },
  { timestamps: true },
);

ingredientSchema.index({ name: 'text', aliases: 'text' });

ingredientSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Ingredient = InferSchemaType<typeof ingredientSchema>;

export const IngredientModel = model('Ingredient', ingredientSchema);
