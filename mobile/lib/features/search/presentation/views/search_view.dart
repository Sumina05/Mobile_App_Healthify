import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_providers.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/status_view.dart';
import '../../../ingredients/presentation/widgets/ingredient_detail_sheet.dart';
import '../../../products/presentation/widgets/product_detail_sheet.dart';
import '../../data/search_repository.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _controller = TextEditingController();
  Timer? _debounce;
  AsyncValue<SearchResults?> _results = const AsyncData(null);

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value);
    });
  }

  Future<void> _search(String rawQuery) async {
    final query = rawQuery.trim();
    if (query.length < 2) {
      setState(() => _results = const AsyncData(null));
      return;
    }
    setState(() => _results = const AsyncLoading());
    try {
      final results =
          await ref.read(searchRepositoryProvider).search(query);
      await ref.read(preferencesServiceProvider).addSearchTerm(query);
      if (mounted) setState(() => _results = AsyncData(results));
    } catch (error, stackTrace) {
      if (mounted) {
        setState(() => _results = AsyncError(error, stackTrace));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.read(preferencesServiceProvider).searchHistory;

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.sm,
                AppSpacing.screen,
                0,
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: _onChanged,
                onSubmitted: _search,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search ingredients or products…',
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: () {
                            _controller.clear();
                            setState(
                                () => _results = const AsyncData(null));
                          },
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: switch (_results) {
                AsyncValue(value: final SearchResults results) =>
                  results.isEmpty
                      ? const StatusView.empty(
                          title: 'No matches',
                          message:
                              'Try a different spelling, an alias (e.g. "Vitamin B3"), or a brand name.',
                        )
                      : _ResultsList(results: results),
                AsyncValue(:final error?, isLoading: false) =>
                  StatusView.forError(
                    error,
                    fallbackMessage: 'Search failed.',
                    onRetry: () => _search(_controller.text),
                  ),
                AsyncValue(isLoading: true) => AppLoader.fullscreen(),
                _ => _HistoryPanel(
                    history: history,
                    onTap: (term) {
                      _controller.text = term;
                      _search(term);
                    },
                    onClear: () async {
                      await ref
                          .read(preferencesServiceProvider)
                          .clearSearchHistory();
                      setState(() {});
                    },
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({
    required this.history,
    required this.onTap,
    required this.onClear,
  });

  final List<String> history;
  final void Function(String) onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (history.isEmpty) {
      return const StatusView.empty(
        title: 'Search Healthify',
        message:
            'Look up any ingredient ("niacinamide", "retinol") or product to see its full breakdown.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Searches', style: theme.textTheme.titleSmall),
            TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: history
              .map(
                (term) => ActionChip(
                  avatar: const Icon(Icons.history_rounded, size: 16),
                  label: Text(term),
                  onPressed: () => onTap(term),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.results});

  final SearchResults results;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        if (results.ingredients.isNotEmpty) ...[
          Text('Ingredients (${results.ingredients.length})',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          ...results.ingredients.map(
            (ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Card(
                child: ListTile(
                  onTap: () => showIngredientDetail(context, ingredient),
                  leading: CircleAvatar(
                    backgroundColor: safetyColor(ingredient.safetyRating)
                        .withValues(alpha: 0.15),
                    child: Icon(
                      Icons.science_rounded,
                      color: safetyColor(ingredient.safetyRating),
                      size: 20,
                    ),
                  ),
                  title: Text(ingredient.name),
                  subtitle: Text(
                    ingredient.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    safetyLabel(ingredient.safetyRating),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: safetyColor(ingredient.safetyRating),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
        if (results.products.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text('Products (${results.products.length})',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          // Opens the shared product sheet so a search hit can be analyzed,
          // rather than just expanding to show its ingredient chips.
          ...results.products.map(
            (product) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Card(
                child: ListTile(
                  onTap: () => showProductDetail(context, product),
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(product.name,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text('${product.brand} · ${product.category}'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
