import { NotificationModel } from './notification.model';

export class NotificationService {
  async create(
    userId: string,
    title: string,
    body: string,
    type: 'welcome' | 'tip' | 'reminder' | 'recommendation' | 'system',
  ) {
    return NotificationModel.create({ userId, title, body, type });
  }

  async listForUser(userId: string) {
    return NotificationModel.find({ userId })
      .sort({ createdAt: -1 })
      .limit(50)
      .exec();
  }

  async unreadCount(userId: string): Promise<number> {
    return NotificationModel.countDocuments({ userId, read: false }).exec();
  }

  async markRead(userId: string, notificationId: string) {
    return NotificationModel.findOneAndUpdate(
      { _id: notificationId, userId },
      { read: true },
      { returnDocument: 'after' },
    ).exec();
  }

  async markAllRead(userId: string): Promise<void> {
    await NotificationModel.updateMany({ userId, read: false }, { read: true });
  }
}

export const notificationService = new NotificationService();
