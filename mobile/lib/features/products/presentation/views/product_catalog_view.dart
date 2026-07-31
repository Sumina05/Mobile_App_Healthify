import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_view.dart';
import '../../domain/product.dart';
import '../viewmodels/product_catalog_viewmodel.dart';
import '../widgets/product_detail_sheet.dart';

/// Browsable product catalog with search, category facets and paging.
class ProductCatalogView extends ConsumerStatefulWidget {
  const ProductCatalogView({super.key});

  @override
  ConsumerState<ProductCatalogView> createState() => _ProductCatalogViewState();
}

class _ProductCatalogViewState extends ConsumerState<ProductCatalogView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      ref.read(productCatalogViewModelProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productCatalogViewModelProvider);
    final viewModel = ref.read(productCatalogViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () => context.push(RoutePaths.barcodeScanner),
            icon: const Icon(Icons.qr_code_scanner_rounded),
            tooltip: 'Scan a barcode',
          ),
        ],
      ),
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
                decoration: InputDecoration(
                  hintText: 'Search products or brands',
                  prefixIcon: const Icon(Icons.search_rounded),
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
            if (state.value case final value? when value.categories.isNotEmpty)
              _CategoryFilterBar(
                categories: value.categories,
                selected: value.category,
                onSelect: viewModel.selectCategory,
              ),
            Expanded(
              child: switch (state) {
                AsyncValue(:final value?) => _CatalogBody(
                    state: value,
                    scrollController: _scrollController,
                    onRefresh: viewModel.refresh,
                  ),
                AsyncValue(:final error?, isLoading: false) =>
                  StatusView.forError(
                    error,
                    fallbackMessage: 'Could not load the product catalog.',
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

class _CategoryFilterBar extends StatelessWidget {
  const _CategoryFilterBar({
    required this.categories,
    required this.selected,
    required this.onSelect,
  });

  final List<String> categories;
  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final category = categories[i];
          final isSelected = category == selected;
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onSelect(category),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
  });

  final ProductCatalogState state;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.isSearching && state.products.isEmpty) {
      return const SkeletonList();
    }

    if (state.products.isEmpty) {
      return StatusView.empty(
        title: state.hasFilters ? 'No products found' : 'Catalog is empty',
        message: state.hasFilters
            ? 'Nothing matches those filters. Try a different brand or category.'
            : 'Products will appear here once the catalog is populated.',
        onRetry: onRefresh,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.md,
          AppSpacing.screen,
          AppSpacing.xl,
        ),
        // One extra row carries the paging indicator.
        itemCount: state.products.length + 1,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, i) {
          if (i == state.products.length) {
            if (state.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.base),
                child: Center(child: AppLoader(size: 24)),
              );
            }
            if (!state.hasMore && state.total > 0) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.base),
                child: Text(
                  'All ${state.total} products shown',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }
            return const SizedBox.shrink();
          }
          return _ProductTile(product: state.products[i]);
        },
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final CatalogProduct product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => showProductDetail(context, product),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: theme.colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${product.brand} · ${product.category}',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // A list card only ever carries a summary (see CatalogProduct);
              // the ingredient count lives on ProductDetail and is fetched
              // once the product is actually opened, not shown here.
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
