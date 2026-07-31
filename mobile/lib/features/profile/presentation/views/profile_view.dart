import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/app_exception.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/viewmodels/auth_controller.dart';
import '../../data/profile_repository.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  bool _uploadingAvatar = false;

  /// Picks from the gallery and uploads. image_picker requests the platform
  /// permission itself and returns null when the user cancels or denies, so
  /// there is no separate permission branch to handle.
  Future<void> _changePhoto() async {
    if (_uploadingAvatar) return;
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        // Avatars render at 84px; full-resolution photos are needless upload.
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return; // Cancelled.

      setState(() => _uploadingAvatar = true);
      final user =
          await ref.read(profileRepositoryProvider).uploadAvatar(picked.path);
      // Push into auth state so every screen showing the user updates at once.
      ref.read(authControllerProvider.notifier).updateUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated')),
        );
      }
    } on AppException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update your photo')),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingAvatar = false);
    }
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final formKey = GlobalKey<FormState>();
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit name'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            validator: Validators.name,
            decoration: const InputDecoration(hintText: 'Your name'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(dialogContext).pop(controller.text.trim());
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName == null || newName == currentName) return;
    try {
      final user =
          await ref.read(profileRepositoryProvider).updateMe(name: newName);
      ref.read(authControllerProvider.notifier).updateUser(user);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update name')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = ref.watch(authControllerProvider);
    if (auth is! Authenticated) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final user = auth.user;
    final profile = user.skinProfile;
    final initials = user.name
        .trim()
        .split(RegExp(r'\s+'))
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    Future<void> confirmLogout() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Log out?'),
          content: const Text(
            'You can log back in anytime with your email and password.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Log out'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        await ref.read(authControllerProvider.notifier).logout();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: AppGradients.accent,
                          shape: BoxShape.circle,
                          boxShadow: AppGradients.accentGlow,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: _uploadingAvatar
                            ? const Center(
                                child: SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : user.avatarUrl != null
                                ? Image.network(
                                    user.avatarUrl!,
                                    fit: BoxFit.cover,
                                    // Fall back to initials if the file is
                                    // unreachable rather than showing a
                                    // broken-image glyph.
                                    errorBuilder: (_, _, _) =>
                                        _Initials(initials: initials),
                                  )
                                : _Initials(initials: initials),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Material(
                          color: theme.colorScheme.surfaceContainerHighest,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: _uploadingAvatar ? null : _changePhoto,
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.xs),
                              child: Icon(
                                Icons.photo_camera_rounded,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton.icon(
                    onPressed: _uploadingAvatar ? null : _changePhoto,
                    icon: const Icon(Icons.image_outlined, size: 18),
                    label: Text(
                      _uploadingAvatar
                          ? 'Uploading…'
                          : user.avatarUrl == null
                              ? 'Upload Photo'
                              : 'Change Photo',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(user.name, style: theme.textTheme.titleLarge),
                      IconButton(
                        onPressed: () => _editName(context, ref, user.name),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        tooltip: 'Edit name',
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  Text(user.email, style: theme.textTheme.bodySmall),
                  if (user.isPremium) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Chip(
                      avatar: const Icon(Icons.workspace_premium_rounded,
                          size: 16, color: AppColors.warning),
                      label: Text(
                        'Premium · ${user.premium!.plan}',
                        style: theme.textTheme.labelSmall,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                  if (profile != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        Chip(
                          label: Text(
                            '${profile.skinType[0].toUpperCase()}${profile.skinType.substring(1)} skin',
                          ),
                          avatar: const Icon(Icons.spa_rounded,
                              size: 16, color: AppColors.mint),
                        ),
                        ...profile.concerns.take(3).map(
                              (c) => Chip(
                                label: Text(c.replaceAll('_', ' ')),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.workspace_premium_rounded,
                        color: AppColors.warning),
                    title: Text(
                      user.isPremium ? 'Manage Premium' : 'Go Premium',
                    ),
                    subtitle: user.isPremium
                        ? null
                        : const Text('Unlimited scans & advanced AI'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.premium),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.face_retouching_natural_rounded),
                    title: Text(
                      profile == null
                          ? 'Complete Skin Profile'
                          : 'Edit Skin Profile',
                    ),
                    subtitle: profile == null
                        ? const Text('Unlock personalized recommendations')
                        : null,
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.skinProfile),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.science_outlined),
                    title: const Text('Ingredient Library'),
                    subtitle: const Text('Browse and search every ingredient'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.ingredients),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.inventory_2_outlined),
                    title: const Text('Product Catalog'),
                    subtitle: const Text('Analyze a product without scanning'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.products),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.favorite_border_rounded),
                    title: const Text('Favorites'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.favorites),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.history_rounded),
                    title: const Text('History'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.history),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.push(RoutePaths.settings),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: ListTile(
                leading:
                    const Icon(Icons.logout_rounded, color: AppColors.danger),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: confirmLogout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Initials shown until a photo is uploaded, or if it fails to load.
class _Initials extends StatelessWidget {
  const _Initials({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
