import { InferSchemaType, Schema, model } from 'mongoose';

const favoriteSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    ingredientId: {
      type: Schema.Types.ObjectId,
      ref: 'Ingredient',
      required: true,
    },
  },
  { timestamps: true },
);

favoriteSchema.index({ userId: 1, ingredientId: 1 }, { unique: true });

favoriteSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Favorite = InferSchemaType<typeof favoriteSchema>;

export const FavoriteModel = model('Favorite', favoriteSchema);
