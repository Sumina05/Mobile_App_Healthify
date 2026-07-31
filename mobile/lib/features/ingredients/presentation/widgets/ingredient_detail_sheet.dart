import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../favorites/presentation/viewmodels/favorites_viewmodel.dart';
import '../../domain/ingredient.dart';

Color safetyColor(String rating) => switch (rating) {
      'safe' => AppColors.success,
      'caution' => AppColors.warning,
      _ => AppColors.danger,
    };

String safetyLabel(String rating) => switch (rating) {
      'safe' => 'Safe',
      'caution' => 'Watch',
      _ => 'Avoid',
    };

/// Bottom sheet with the full ingredient breakdown + favorite toggle.
void showIngredientDetail(BuildContext context, Ingredient ingredient) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _IngredientDetailSheet(ingredient: ingredient),
  );
}

class _IngredientDetailSheet extends ConsumerWidget {
  const _IngredientDetailSheet({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritesViewModelProvider);
    final isFavorite =
        favorites.value?.any((f) => f.ingredient.id == ingredient.id) ??
            false;

    Future<void> toggleFavorite() async {
      final vm = ref.read(favoritesViewModelProvider.notifier);
      try {
        if (isFavorite) {
          final item = (favorites.value ?? [])
              .firstWhere((f) => f.ingredient.id == ingredient.id);
          await vm.remove(item);
        } else {
          await vm.addIngredient(ingredient.id);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not update favorites: $e')),
          );
        }
      }
    }

    Widget chipRow(String title, List<String> values, {Color? color}) {
      if (values.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.base),
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: values
                .map(
                  (v) => Chip(
                    label: Text(v),
                    side: color != null
                        ? BorderSide(color: color.withValues(alpha: 0.5))
                        : null,
                  ),
                )
                .toList(),
          ),
        ],
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ingredient.name,
                            style: theme.textTheme.headlineSmall),
                        if (ingredient.aliases.isNotEmpty)
                          Text(
                            ingredient.aliases.join(' · '),
                            style: theme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: toggleFavorite,
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite
                          ? AppColors.danger
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: safetyColor(ingredient.safetyRating)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  '${safetyLabel(ingredient.safetyRating)} · ${ingredient.tagline}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: safetyColor(ingredient.safetyRating),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
              Text('Purpose', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(ingredient.purpose, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.base),
              Text('About', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(ingredient.description, style: theme.textTheme.bodyMedium),
              chipRow('Benefits', ingredient.benefits,
                  color: AppColors.success),
              chipRow('Possible Side Effects', ingredient.sideEffects,
                  color: AppColors.warning),
              chipRow('Good For', ingredient.goodForSkinTypes),
              chipRow('Use Caution', ingredient.cautionForSkinTypes,
                  color: AppColors.danger),
            ],
          ),
        );
      },
    );
  }
}
