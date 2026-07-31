import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../analysis/presentation/viewmodels/analysis_viewmodels.dart';
import '../../domain/product.dart';
import '../viewmodels/product_detail_viewmodel.dart';

/// Opens the product detail sheet for a search or catalogue result. The list
/// only ever carries a summary (no ingredients), so the sheet fetches the
/// full [ProductDetail] itself via [product]'s slug and shows a loading
/// state while that's in flight.
void showProductDetail(BuildContext context, CatalogProduct product) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ProductDetailSheet(
      name: product.name,
      brand: product.brand,
      category: product.category,
      slug: product.slug,
      preloaded: null,
    ),
  );
}

/// Opens the same sheet for a barcode/OCR-scanned product. Barcode lookups
/// already return the full record (the web API's barcode and slug endpoints
/// share one DTO), so this skips straight to the loaded state — no second
/// network call, and it still renders through the exact same UI as Search
/// and Categories.
void showProductDetailFromBarcode(BuildContext context, BarcodeProduct product) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ProductDetailSheet(
      name: product.name,
      brand: product.brand,
      category: product.category,
      slug: product.slug,
      preloaded: product.toProductDetail(),
    ),
  );
}

class _ProductDetailSheet extends ConsumerWidget {
  const _ProductDetailSheet({
    required this.name,
    required this.brand,
    required this.category,
    required this.slug,
    required this.preloaded,
  });

  final String name;
  final String brand;
  final String category;
  final String slug;

  /// Already-complete data (barcode/OCR path) — when set, no fetch happens.
  final ProductDetail? preloaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preloaded = this.preloaded;
    // One AsyncValue drives the whole sheet regardless of how the product
    // was reached: already-loaded data, a live fetch by slug, or (a product
    // with no catalogue record at all, e.g. an Open Facts barcode hit) an
    // explicit "nothing more to load" error rather than a silent empty state.
    final AsyncValue<ProductDetail> detailAsync = preloaded != null
        ? AsyncValue.data(preloaded)
        : slug.isEmpty
            ? AsyncValue.error(
                StateError('No catalogue record for this product'),
                StackTrace.empty,
              )
            : ref.watch(productDetailProvider(slug));

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return switch (detailAsync) {
          AsyncValue(:final value?) => _DetailBody(
              detail: value,
              scrollController: scrollController,
            ),
          AsyncValue(:final error?, isLoading: false) => SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: StatusView.forError(
                  error,
                  fallbackMessage: 'Could not load this product.',
                  onRetry: slug.isEmpty
                      ? null
                      : () => ref.invalidate(productDetailProvider(slug)),
                ),
              ),
            ),
          _ => SizedBox(
              // A named header while it loads, rather than a bare spinner —
              // the sheet already knows this much from the summary.
              height: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.lg),
                  AppLoader.fullscreen(),
                ],
              ),
            ),
        };
      },
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.detail, required this.scrollController});

  final ProductDetail detail;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final submitState = ref.watch(analyzeSubmitProvider);

    ref.listen(analyzeSubmitProvider, (_, next) {
      if (next.hasError && !next.isLoading) {
        final error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is AppException ? error.message : 'Analysis failed',
            ),
          ),
        );
      }
    });

    Future<void> analyze() async {
      final analysis = await ref.read(analyzeSubmitProvider.notifier).submit(
            productName: detail.name,
            brand: detail.brand,
            ingredients: detail.ingredientNames,
          );
      if (analysis == null || !context.mounted) return;
      Navigator.of(context).pop();
      context.push('${RoutePaths.analysis}/${analysis.id}');
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      children: [
        if (detail.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Image.network(
                detail.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
        if (detail.imageUrl != null) const SizedBox(height: AppSpacing.base),
        Text(detail.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${detail.brand} · ${detail.category}',
          style: theme.textTheme.bodyMedium,
        ),
        if (detail.safetyScore != null) ...[
          const SizedBox(height: AppSpacing.sm),
          _SafetyBadge(score: detail.safetyScore!, band: detail.safetyBand),
        ],
        if (detail.description.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('About', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(detail.description, style: theme.textTheme.bodyMedium),
        ],
        if (detail.suitableSkinTypes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Suits', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _ChipRow(values: detail.suitableSkinTypes),
        ],
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Ingredients (${detail.ingredientNames.length})',
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        if (detail.ingredientNames.isEmpty)
          Text(
            'This product has no ingredient list on file yet.',
            style: theme.textTheme.bodySmall,
          )
        else
          _ChipRow(values: detail.ingredientNames),
        if (detail.benefits.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Benefits', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _ChipRow(values: detail.benefits, color: AppColors.success),
        ],
        if (detail.sideEffects.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text('Possible Side Effects', style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          _ChipRow(values: detail.sideEffects, color: AppColors.warning),
        ],
        const SizedBox(height: AppSpacing.lg),
        GradientButton(
          label: 'Analyze for My Skin',
          icon: Icons.auto_awesome_rounded,
          isLoading: submitState.isLoading,
          onPressed: detail.ingredientNames.isEmpty ? null : analyze,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Scores this product against your skin profile, allergies and '
          'ingredients to avoid.',
          style: theme.textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SafetyBadge extends StatelessWidget {
  const _SafetyBadge({required this.score, this.band});

  final int score;
  final String? band;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = switch (band) {
      'excellent' || 'good' => AppColors.success,
      'caution' => AppColors.warning,
      'poor' => AppColors.danger,
      _ => theme.colorScheme.primary,
    };
    final label = band == null
        ? 'Safety $score/100'
        : '${band![0].toUpperCase()}${band!.substring(1)} · $score/100';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: color),
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.values, this.color});

  final List<String> values;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: values
          .map(
            (value) => Chip(
              label: Text(value),
              visualDensity: VisualDensity.compact,
              side: color != null
                  ? BorderSide(color: color!.withValues(alpha: 0.5))
                  : null,
            ),
          )
          .toList(),
    );
  }
}
