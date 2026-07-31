import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../ingredients/presentation/widgets/ingredient_detail_sheet.dart';
import '../viewmodels/favorites_viewmodel.dart';

class FavoritesView extends ConsumerWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favoritesViewModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: SafeArea(
        child: switch (state) {
          AsyncValue(:final value?) when value.isEmpty => const StatusView.empty(
              title: 'No favorites yet',
              message:
                  'Tap the heart on any ingredient to save it here for quick access.',
            ),
          AsyncValue(:final value?) => RefreshIndicator(
              onRefresh: () =>
                  ref.read(favoritesViewModelProvider.notifier).refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.screen),
                itemCount: value.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, i) {
                  final item = value[i];
                  return Card(
                    child: ListTile(
                      onTap: () =>
                          showIngredientDetail(context, item.ingredient),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.base,
                        vertical: AppSpacing.xs,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: safetyColor(
                          item.ingredient.safetyRating,
                        ).withValues(alpha: 0.15),
                        child: Icon(
                          Icons.science_rounded,
                          color: safetyColor(item.ingredient.safetyRating),
                          size: 20,
                        ),
                      ),
                      title: Text(item.ingredient.name),
                      subtitle: Text(
                        item.ingredient.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.danger,
                        ),
                        onPressed: () async {
                          try {
                            await ref
                                .read(favoritesViewModelProvider.notifier)
                                .remove(item);
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Could not remove — try again'),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          AsyncValue(:final error?, isLoading: false) => StatusView.forError(
              error,
              fallbackMessage: 'Could not load favorites.',
              onRetry: () =>
                  ref.read(favoritesViewModelProvider.notifier).refresh(),
            ),
          _ => AppLoader.fullscreen(),
        },
      ),
    );
  }
}
