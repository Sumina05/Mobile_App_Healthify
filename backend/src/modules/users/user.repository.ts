import { UserRole } from '../../utils/jwt';
import { SkinProfile, UserDocument, UserModel } from './user.model';

/** Only layer that touches the User collection. */
export class UserRepository {
  findById(id: string): Promise<UserDocument | null> {
    return UserModel.findById(id).exec();
  }

  findByEmail(email: string): Promise<UserDocument | null> {
    return UserModel.findOne({ email: email.toLowerCase() }).exec();
  }

  findByEmailWithSecrets(email: string): Promise<UserDocument | null> {
    return UserModel.findOne({ email: email.toLowerCase() })
      .select('+passwordHash +passwordReset')
      .exec();
  }

  findByGoogleId(googleId: string): Promise<UserDocument | null> {
    return UserModel.findOne({ googleId }).exec();
  }

  /** Links a Google account to an existing local (password) account. */
  linkGoogleId(id: string, googleId: string): Promise<UserDocument | null> {
    return UserModel.findByIdAndUpdate(
      id,
      { googleId, provider: 'google' },
      { returnDocument: 'after' },
    ).exec();
  }

  /**
   * [role] is only ever supplied by the seeder. Registration cannot reach it:
   * `registerSchema` does not accept a role and `authService.register` passes
   * only name/email/passwordHash, so accounts always default to 'user'.
   */
  create(data: {
    name: string;
    email: string;
    passwordHash?: string;
    provider?: 'local' | 'google';
    googleId?: string;
    avatarUrl?: string;
    role?: UserRole;
  }): Promise<UserDocument> {
    return UserModel.create(data);
  }

  updateById(
    id: string,
    update: Partial<{ name: string; avatarUrl: string | null }>,
  ): Promise<UserDocument | null> {
    return UserModel.findByIdAndUpdate(id, update, {
      returnDocument: 'after',
      runValidators: true,
    }).exec();
  }

  setSkinProfile(
    id: string,
    profile: SkinProfile,
  ): Promise<UserDocument | null> {
    return UserModel.findByIdAndUpdate(
      id,
      { skinProfile: profile },
      { returnDocument: 'after', runValidators: true },
    ).exec();
  }

  async setPasswordReset(
    id: string,
    reset: { codeHash: string; expiresAt: Date } | null,
  ): Promise<void> {
    await UserModel.findByIdAndUpdate(id, { passwordReset: reset }).exec();
  }

  async updatePassword(id: string, passwordHash: string): Promise<void> {
    await UserModel.findByIdAndUpdate(id, {
      passwordHash,
      passwordReset: null,
    }).exec();
  }
}

export const userRepository = new UserRepository();
