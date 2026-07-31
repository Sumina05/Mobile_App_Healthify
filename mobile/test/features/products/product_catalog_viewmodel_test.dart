import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/features/products/data/products_repository.dart';
import 'package:healthify_mobile/features/products/domain/product.dart';
import 'package:healthify_mobile/features/products/presentation/viewmodels/product_catalog_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

CatalogProduct _product(String id, {String category = 'Cleanser'}) =>
    CatalogProduct(
      id: id,
      slug: 'product-$id',
      name: 'Product $id',
      brand: 'Brand',
      category: category,
    );

const _categories = ['Cleanser', 'Serum', 'Moisturizer'];

/// Polls until [condition] holds. The view-model debounces on a real
/// [Timer], so a fixed sleep makes these tests flaky on a loaded machine.
Future<void> waitFor(
  bool Function() condition, {
  Duration timeout = const Duration(seconds: 5),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('Condition not met within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  late MockProductsRepository repository;

  ProviderContainer makeContainer() {
    repository = MockProductsRepository();
    final container = ProviderContainer(
      // Riverpod 3 retries failed providers with backoff, which would leave
      // a failed build stuck in AsyncLoading(retrying) forever in tests.
      retry: (_, _) => null,
      overrides: [
        productsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  void stubFetch({
    String search = '',
    String category = '',
    int page = 1,
    required ProductPage result,
  }) {
    when(
      () => repository.fetch(
        search: search,
        category: category,
        page: page,
      ),
    ).thenAnswer((_) async => result);
  }

  final firstPage = ProductPage(
    items: [_product('1'), _product('2')],
    categories: _categories,
    page: 1,
    totalPages: 2,
    total: 4,
  );

  test('initial load exposes products and category facets', () async {
    final container = makeContainer();
    stubFetch(result: firstPage);

    final state = await container.read(productCatalogViewModelProvider.future);

    expect(state.products, hasLength(2));
    expect(state.categories, _categories);
    expect(state.hasMore, isTrue);
    expect(state.hasFilters, isFalse);
  });

  test('loadMore appends the next page rather than replacing it', () async {
    final container = makeContainer();
    stubFetch(result: firstPage);
    stubFetch(
      page: 2,
      result: ProductPage(
        items: [_product('3'), _product('4')],
        page: 2,
        totalPages: 2,
        total: 4,
      ),
    );

    await container.read(productCatalogViewModelProvider.future);
    await container
        .read(productCatalogViewModelProvider.notifier)
        .loadMore();

    final state = container.read(productCatalogViewModelProvider).value!;
    expect(state.products.map((p) => p.id), ['1', '2', '3', '4']);
    expect(state.hasMore, isFalse);
    expect(state.isLoadingMore, isFalse);
  });

  test('loadMore is a no-op on the last page', () async {
    final container = makeContainer();
    stubFetch(
      result: ProductPage(
        items: [_product('1')],
        categories: _categories,
        totalPages: 1,
        total: 1,
      ),
    );

    await container.read(productCatalogViewModelProvider.future);
    await container
        .read(productCatalogViewModelProvider.notifier)
        .loadMore();

    verifyNever(() => repository.fetch(search: '', category: '', page: 2));
  });

  test('selecting a category filters and marks the state as filtered',
      () async {
    final container = makeContainer();
    stubFetch(result: firstPage);
    stubFetch(
      category: 'Serum',
      result: ProductPage(
        items: [_product('9', category: 'Serum')],
        page: 1,
        totalPages: 1,
        total: 1,
      ),
    );

    await container.read(productCatalogViewModelProvider.future);
    await container
        .read(productCatalogViewModelProvider.notifier)
        .selectCategory('Serum');

    final state = container.read(productCatalogViewModelProvider).value!;
    expect(state.category, 'Serum');
    expect(state.products.single.id, '9');
    expect(state.hasFilters, isTrue);
    // The facet list survives a filtered response that omits it.
    expect(state.categories, _categories);
  });

  test('re-selecting the active category clears the filter', () async {
    final container = makeContainer();
    stubFetch(result: firstPage);
    stubFetch(
      category: 'Serum',
      result: ProductPage(items: [_product('9', category: 'Serum')]),
    );

    await container.read(productCatalogViewModelProvider.future);
    final viewModel =
        container.read(productCatalogViewModelProvider.notifier);
    await viewModel.selectCategory('Serum');
    await viewModel.selectCategory('Serum');

    final state = container.read(productCatalogViewModelProvider).value!;
    expect(state.category, isEmpty);
    expect(state.hasFilters, isFalse);
  });

  test('debounce collapses rapid keystrokes into one request', () async {
    final container = makeContainer();
    stubFetch(result: firstPage);
    stubFetch(search: 'gel', result: ProductPage(items: [_product('5')]));

    await container.read(productCatalogViewModelProvider.future);
    final viewModel =
        container.read(productCatalogViewModelProvider.notifier);

    viewModel.search('g');
    viewModel.search('ge');
    viewModel.search('gel');
    await waitFor(() =>
        container.read(productCatalogViewModelProvider).value?.isSearching ==
        false);

    final state = container.read(productCatalogViewModelProvider).value!;
    expect(state.query, 'gel');
    expect(state.products.single.id, '5');
    verifyNever(
      () => repository.fetch(search: 'g', category: '', page: 1),
    );
    verifyNever(
      () => repository.fetch(search: 'ge', category: '', page: 1),
    );
  });

  test('a failed initial load surfaces as an error state', () async {
    final container = makeContainer();
    when(() => repository.fetch(search: '', category: '', page: 1))
        .thenAnswer((_) async => throw Exception('offline'));

    await expectLater(
      container.read(productCatalogViewModelProvider.future),
      throwsA(isA<Exception>()),
    );
    expect(container.read(productCatalogViewModelProvider).hasError, isTrue);
  });
}
