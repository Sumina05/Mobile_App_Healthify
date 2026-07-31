import { ApiError } from '../../utils/api-error';
import { notificationService } from '../notifications/notification.service';
import { UserDocument } from './user.model';
import { userRepository } from './user.repository';
import { SkinProfileInput } from './user.validation';

export class UserService {
  async getById(id: string): Promise<UserDocument> {
    const user = await userRepository.findById(id);
    if (!user) throw ApiError.notFound('User not found');
    return user;
  }

  async updateMe(
    id: string,
    update: { name?: string; avatarUrl?: string | null },
  ): Promise<UserDocument> {
    const user = await userRepository.updateById(id, update);
    if (!user) throw ApiError.notFound('User not found');
    return user;
  }

  async setSkinProfile(
    id: string,
    profile: SkinProfileInput,
  ): Promise<UserDocument> {
    const existing = await userRepository.findById(id);
    if (!existing) throw ApiError.notFound('User not found');
    const isFirstTime = existing.skinProfile == null;

    const user = await userRepository.setSkinProfile(id, {
      ...profile,
      completedAt: new Date(),
    });

    if (isFirstTime) {
      await notificationService.create(
        id,
        'Skin profile complete ✨',
        'Your analyses and recommendations are now personalized to your skin.',
        'tip',
      );
    }
    return user!;
  }
}

export const userService = new UserService();
