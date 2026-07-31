import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/ingredient.dart';
import '../viewmodels/ingredient_library_viewmodel.dart';
import '../widgets/ingredient_detail_sheet.dart';
import '../widgets/ingredient_tile.dart';

/// Browsable ingredient database: today's featured ingredient, picks ranked
/// against the user's skin profile, and search across the whole catalogue.
class IngredientLibraryView extends ConsumerStatefulWidget {
  const IngredientLibraryView({super.key});

  @override
  ConsumerState<IngredientLibraryView> createState() =>
      _IngredientLibraryViewState();
}

class _IngredientLibraryViewState extends ConsumerState<IngredientLibraryView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ingredientLibraryViewModelProvider);
    final viewModel = ref.read(ingredientLibraryViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Ingredients')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                0,
                AppSpacing.screen,
                AppSpacing.md,
              ),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                onChanged: viewModel.search,
                onSubmitted: (value) => viewModel.runSearch(value.trim()),
                decoration: InputDecoration(
                  hintText: 'Search ingredients, e.g. niacinamide',
                  prefixIcon: const Icon(Icons.search_rounded),
                  // Driven by the controller so the button tracks the field
                  // itself rather than the debounced view-model query.
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _controller,
                    builder: (context, value, _) => value.text.isEmpty
                        ? const SizedBox.shrink()
                        : IconButton(
                            icon: const Icon(Icons.close_rounded),
                            tooltip: 'Clear search',
                            onPressed: () {
                              _controller.clear();
                              viewModel.search('');
                            },
                          ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: switch (state) {
                AsyncValue(:final value?) => _LibraryBody(
                    state: value,
                    onRefresh: viewModel.refresh,
                  ),
                AsyncValue(:final error?, isLoading: false) =>
                  StatusView.forError(
                    error,
                    fallbackMessage: 'Could not load the ingredient library.',
                    onRetry: viewModel.refresh,
                  ),
                _ => const SkeletonList(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LibraryBody extends StatelessWidget {
  const _LibraryBody({required this.state, required this.onRefresh});

  final IngredientLibraryState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.isSearching && state.results.isEmpty) {
      return const SkeletonList();
    }

    if (!state.showsDiscovery && state.results.isEmpty) {
      return StatusView.empty(
        title: 'No matches',
        message: 'Nothing in our database matches "${state.query}" yet.',
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.xl,
        ),
        children: [
          if (state.showsDiscovery) ...[
            if (state.ingredientOfTheDay != null)
              _FeaturedIngredientCard(ingredient: state.ingredientOfTheDay!),
            if (state.recommended.isNotEmpty) ...[
              const SectionHeader(title: 'Recommended for your skin'),
              ...state.recommended.map(
                (ingredient) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: IngredientTile(ingredient: ingredient),
                ),
              ),
            ],
            const SectionHeader(title: 'All ingredients'),
          ],
          ...state.results.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: IngredientTile(ingredient: ingredient),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedIngredientCard extends StatelessWidget {
  const _FeaturedIngredientCard({required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => showIngredientDetail(context, ingredient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 18,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'INGREDIENT OF THE DAY',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(ingredient.name, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          Text(ingredient.tagline, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Text(
            ingredient.purpose,
            style: theme.textTheme.bodySmall,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
