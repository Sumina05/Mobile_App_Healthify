import { InferSchemaType, Schema, model } from 'mongoose';

const paymentSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    provider: { type: String, enum: ['khalti', 'esewa'], required: true },
    plan: { type: String, enum: ['monthly', 'yearly'], required: true },
    amountNpr: { type: Number, required: true },
    status: {
      type: String,
      enum: ['created', 'completed', 'failed'],
      default: 'created',
    },
    /** Khalti pidx / eSewa transaction uuid. */
    providerRef: { type: String, required: true, unique: true },
    /** True when no gateway keys are configured (dev checkout). */
    simulated: { type: Boolean, default: false },
  },
  { timestamps: true },
);

paymentSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Payment = InferSchemaType<typeof paymentSchema>;

export const PaymentModel = model('Payment', paymentSchema);
