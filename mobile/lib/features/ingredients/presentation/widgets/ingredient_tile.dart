import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/ingredient.dart';
import 'ingredient_detail_sheet.dart';

/// Compact ingredient row used by the library and search results.
class IngredientTile extends StatelessWidget {
  const IngredientTile({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safety = safetyColor(ingredient.safetyRating);

    return Card(
      child: InkWell(
        onTap: () => showIngredientDetail(context, ingredient),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: safety.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(Icons.science_rounded, color: safety, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      ingredient.tagline,
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              if (ingredient.isCommonAllergen)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Tooltip(
                    message: 'Common allergen',
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              Text(
                safetyLabel(ingredient.safetyRating),
                style: theme.textTheme.labelSmall?.copyWith(color: safety),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
