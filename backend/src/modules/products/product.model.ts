import { InferSchemaType, Schema, model } from 'mongoose';

/** Catalog products used for alternative recommendations & comparison. */
const productSchema = new Schema(
  {
    name: { type: String, required: true, unique: true },
    brand: { type: String, required: true },
    category: { type: String, required: true },
    ingredientNames: { type: [String], required: true },
  },
  { timestamps: true },
);

productSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Product = InferSchemaType<typeof productSchema>;

export const ProductModel = model('Product', productSchema);
