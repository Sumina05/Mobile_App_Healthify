import { InferSchemaType, Schema, model } from 'mongoose';

const notificationSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    title: { type: String, required: true },
    body: { type: String, required: true },
    type: {
      type: String,
      enum: ['welcome', 'tip', 'reminder', 'recommendation', 'system'],
      default: 'system',
    },
    read: { type: Boolean, default: false },
  },
  { timestamps: true },
);

notificationSchema.set('toJSON', {
  versionKey: false,
  transform: (_doc, ret: Record<string, unknown>) => {
    ret.id = String(ret._id);
    delete ret._id;
    return ret;
  },
});

export type Notification = InferSchemaType<typeof notificationSchema>;

export const NotificationModel = model('Notification', notificationSchema);
