import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../analysis/domain/product_analysis.dart';
import '../../../analysis/presentation/viewmodels/analysis_viewmodels.dart';
import '../viewmodels/scanner_viewmodel.dart';

/// Post-OCR review: confirm/edit the detected ingredients, optionally name
/// the product, then send everything to the analysis engine. Returns the
/// created analysis, or null if dismissed.
Future<ProductAnalysis?> showScanReviewSheet(
  BuildContext context,
  ScanResult result,
) {
  return showModalBottomSheet<ProductAnalysis>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _ScanReviewSheet(result: result),
  );
}

class _ScanReviewSheet extends ConsumerStatefulWidget {
  const _ScanReviewSheet({required this.result});

  final ScanResult result;

  @override
  ConsumerState<_ScanReviewSheet> createState() => _ScanReviewSheetState();
}

class _ScanReviewSheetState extends ConsumerState<_ScanReviewSheet> {
  final _productName = TextEditingController();
  final _brand = TextEditingController();
  final _addIngredient = TextEditingController();
  late final List<String> _ingredients =
      widget.result.ingredients.toSet().toList();

  @override
  void dispose() {
    _productName.dispose();
    _brand.dispose();
    _addIngredient.dispose();
    super.dispose();
  }

  Future<void> _analyze() async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keep at least one ingredient')),
      );
      return;
    }
    final analysis =
        await ref.read(analyzeSubmitProvider.notifier).submit(
              productName: _productName.text.trim(),
              brand: _brand.text.trim(),
              rawText: widget.result.rawText,
              ingredients: _ingredients,
            );
    if (analysis != null && mounted) {
      Navigator.of(context).pop(analysis);
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            0,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          children: [
            Text('Review Scan', style: theme.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '${_ingredients.length} ingredients detected — remove OCR '
              'mistakes or add anything missing before analyzing.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.base),
            TextField(
              controller: _productName,
              decoration: const InputDecoration(
                hintText: 'Product name (optional)',
                prefixIcon: Icon(Icons.inventory_2_outlined, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _brand,
              decoration: const InputDecoration(
                hintText: 'Brand (optional)',
                prefixIcon: Icon(Icons.storefront_outlined, size: 20),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: _ingredients
                  .map(
                    (name) => InputChip(
                      label: Text(name),
                      onDeleted: () =>
                          setState(() => _ingredients.remove(name)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _addIngredient,
              decoration: const InputDecoration(
                hintText: 'Add ingredient — press enter',
                prefixIcon: Icon(Icons.add_rounded, size: 20),
              ),
              onSubmitted: (value) {
                final trimmed = value.trim();
                if (trimmed.length >= 2 &&
                    !_ingredients.contains(trimmed)) {
                  setState(() => _ingredients.add(trimmed));
                }
                _addIngredient.clear();
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            GradientButton(
              label: 'Analyze with AI',
              icon: Icons.auto_awesome_rounded,
              isLoading: submitState.isLoading,
              onPressed: _analyze,
            ),
          ],
        );
      },
    );
  }
}
