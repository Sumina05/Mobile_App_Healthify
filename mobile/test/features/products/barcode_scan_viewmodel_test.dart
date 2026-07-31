import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/error/app_exception.dart';
import 'package:healthify_mobile/features/products/data/products_repository.dart';
import 'package:healthify_mobile/features/products/domain/product.dart';
import 'package:healthify_mobile/features/products/presentation/viewmodels/barcode_scan_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

const _product = BarcodeProduct(
  id: 'web-id-001',
  slug: 'la-roche-posay-hydrating-cleanser',
  barcode: '3337875597180',
  name: 'Hydrating Cleanser',
  brand: 'La Roche-Posay',
  category: 'Cleanser',
  description: 'A gentle cleanser for dry skin.',
  ingredientNames: ['Aqua', 'Glycerin'],
  source: 'catalog',
  safetyScore: 88,
  safetyBand: 'excellent',
  suitableSkinTypes: ['dry', 'sensitive'],
  benefits: ['Hydrating'],
  sideEffects: [],
);

void main() {
  late MockProductsRepository repository;

  ProviderContainer makeContainer() {
    repository = MockProductsRepository();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [productsRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    // The provider is autoDispose; keep it alive for the test the way a
    // mounted screen would.
    container.listen(barcodeScanViewModelProvider, (_, _) {});
    return container;
  }

  test('starts in the scanning state', () {
    final container = makeContainer();
    expect(
      container.read(barcodeScanViewModelProvider),
      isA<BarcodeScanning>(),
    );
  });

  test('a known barcode resolves to the product', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode('3337875597180'))
        .thenAnswer((_) async => _product);

    await container
        .read(barcodeScanViewModelProvider.notifier)
        .lookup('3337875597180');

    final state = container.read(barcodeScanViewModelProvider);
    expect(state, isA<BarcodeFound>());
    expect((state as BarcodeFound).product.name, 'Hydrating Cleanser');
  });

  test('an unknown barcode is a not-found outcome, not an error', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode('9999999999999'))
        .thenAnswer((_) async => throw const NotFoundException());

    await container
        .read(barcodeScanViewModelProvider.notifier)
        .lookup('9999999999999');

    final state = container.read(barcodeScanViewModelProvider);
    expect(state, isA<BarcodeNotFound>());
    expect((state as BarcodeNotFound).code, '9999999999999');
  });

  test('a network failure is distinct from not-found', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode(any()))
        .thenAnswer((_) async => throw const NetworkException());

    await container
        .read(barcodeScanViewModelProvider.notifier)
        .lookup('3337875597180');

    final state = container.read(barcodeScanViewModelProvider);
    expect(state, isA<BarcodeLookupFailed>());
    expect(
      (state as BarcodeLookupFailed).message,
      contains('No internet connection'),
    );
  });

  test('repeat detections of the same code hit the API once', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode('3337875597180')).thenAnswer(
      (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        return _product;
      },
    );

    final viewModel = container.read(barcodeScanViewModelProvider.notifier);
    // The camera stream fires continuously while the barcode is in frame.
    final first = viewModel.lookup('3337875597180');
    await viewModel.lookup('3337875597180');
    await viewModel.lookup('3337875597180');
    await first;

    verify(() => repository.findByBarcode('3337875597180')).called(1);
  });

  test('no further lookups happen once a product is found', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode(any()))
        .thenAnswer((_) async => _product);

    final viewModel = container.read(barcodeScanViewModelProvider.notifier);
    await viewModel.lookup('3337875597180');
    await viewModel.lookup('0000000000000');

    expect(container.read(barcodeScanViewModelProvider), isA<BarcodeFound>());
    verifyNever(() => repository.findByBarcode('0000000000000'));
  });

  test('reset re-arms the scanner', () async {
    final container = makeContainer();
    when(() => repository.findByBarcode(any()))
        .thenAnswer((_) async => _product);

    final viewModel = container.read(barcodeScanViewModelProvider.notifier);
    await viewModel.lookup('3337875597180');
    viewModel.reset();

    expect(
      container.read(barcodeScanViewModelProvider),
      isA<BarcodeScanning>(),
    );

    await viewModel.lookup('3337875597180');
    expect(container.read(barcodeScanViewModelProvider), isA<BarcodeFound>());
  });

  group('BarcodeProduct', () {
    test('carries complete detail — same shape a search/catalogue lookup '
        'would eventually fetch — with no further request needed', () {
      final detail = _product.toProductDetail();
      expect(detail.id, 'web-id-001');
      expect(detail.slug, 'la-roche-posay-hydrating-cleanser');
      expect(detail.name, 'Hydrating Cleanser');
      expect(detail.brand, 'La Roche-Posay');
      expect(detail.description, 'A gentle cleanser for dry skin.');
      expect(detail.ingredientNames, ['Aqua', 'Glycerin']);
      expect(detail.safetyScore, 88);
      expect(detail.safetyBand, 'excellent');
      expect(detail.suitableSkinTypes, ['dry', 'sensitive']);
      expect(detail.benefits, ['Hydrating']);
    });

    test('flags community-sourced results', () {
      expect(_product.isCommunitySourced, isFalse);
      expect(
        _product.copyWith(source: 'external').isCommunitySourced,
        isTrue,
      );
    });

    test('parses the backend payload', () {
      final parsed = BarcodeProduct.fromJson(const {
        'id': '769915190837',
        'barcode': '769915190837',
        'name': 'Vitamin C Serum',
        'brand': 'The Ordinary',
        'category': 'Serum',
        'imageUrl': null,
        'ingredientNames': ['Aqua', 'Ascorbic Acid'],
        'source': 'external',
        'safetyScore': null,
      });

      expect(parsed.barcode, '769915190837');
      expect(parsed.ingredientNames, hasLength(2));
      expect(parsed.safetyScore, isNull);
      expect(parsed.isCommunitySourced, isTrue);
    });
  });
}
