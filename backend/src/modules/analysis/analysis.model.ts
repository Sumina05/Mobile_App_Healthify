import { InferSchemaType, Schema, model } from 'mongoose';

const breakdownSchema = new Schema(
  {
    name: { type: String, required: true },
    matched: { type: Boolean, required: true },
    status: {
      type: String,
      enum: ['good', 'neutral', 'caution', 'avoid', 'allergy'],
      required: true,
    },
    reason: { type: String, required: true },
    ingredientId: {
      type: Schema.Types.ObjectId,
      ref: 'Ingredient',
      default: null,
    },
  },
  { _id: false },
);

const alternativeSchema = new Schema(
  {
    productId: { type: Schema.Types.ObjectId, ref: 'Product' },
    name: { type: String, required: true },
    brand: { type: String, required: true },
    category: { type: String, required: true },
    matchPercent: { type: Number, required: true },
  },
  { _id: false },
);

/** A saved product analysis produced by the scoring + AI pipeline. */
const analysisSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    productName: { type: String, default: 'Scanned product' },
    brand: { type: String, default: null },
    rawText: { type: String, default: '' },
    ingredientNames: { type: [String], default: [] },
    score: { type: Number, min: 0, max: 100, required: true },
    verdict: {
      type: String,
      enum: ['excellent', 'good', 'average', 'poor'],
      required: true,
    },
    safetyRating: {
      type: String,
      enum: ['low_risk', 'moderate_risk', 'high_risk'],
      required: true,
    },
    summary: { type: String, default: '' },
    recommendationReason: { type: String, default: '' },
    aiExplanation: { type: String, default: '' },
    warnings: { type: [String], default: [] },
    breakdown: { type: [breakdownSchema], default: [] },
    alternatives: { type: [alternativeSchema], default: [] },
    goodCount: { type: Number, default: 0 },
    watchCount: { type: Number, default: 0 },
    matchedCount: { type: Number, default: 0 },
    favorite: { type: Boolean, default: false },
  },
  { timestamps: true },
);

analysisSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Analysis = InferSchemaType<typeof analysisSchema>;

export const AnalysisModel = model('Analysis', analysisSchema);
