import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/error/app_exception.dart';
import 'package:healthify_mobile/features/products/data/products_repository.dart';
import 'package:healthify_mobile/features/products/domain/product.dart';
import 'package:healthify_mobile/features/products/presentation/viewmodels/product_detail_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

const _detail = ProductDetail(
  id: 'web-id-002',
  slug: 'cetaphil-gentle-skin-cleanser',
  name: 'Gentle Skin Cleanser',
  brand: 'Cetaphil',
  category: 'Cleanser',
  description: 'A soap-free, low-lather cleanser.',
  ingredientNames: ['Aqua', 'Glycerin', 'Panthenol'],
  safetyScore: 92,
  safetyBand: 'excellent',
  suitableSkinTypes: ['normal', 'dry', 'sensitive'],
  benefits: ['Gentle cleansing', 'Hydrating base'],
  sideEffects: ['Occasional allergy'],
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
    return container;
  }

  test('fetches the full record by slug — this is the fix: a search/catalog '
      'result carries only a summary, this is what fills in the rest',
      () async {
    final container = makeContainer();
    when(() => repository.getDetail('cetaphil-gentle-skin-cleanser'))
        .thenAnswer((_) async => _detail);

    final detail = await container
        .read(productDetailProvider('cetaphil-gentle-skin-cleanser').future);

    expect(detail.ingredientNames, ['Aqua', 'Glycerin', 'Panthenol']);
    expect(detail.description, isNotEmpty);
    expect(detail.safetyScore, 92);
    expect(detail.benefits, isNotEmpty);
  });

  test('two different slugs are independent — the family key actually keys',
      () async {
    final container = makeContainer();
    when(() => repository.getDetail('a'))
        .thenAnswer((_) async => _detail.copyWith(slug: 'a', name: 'A'));
    when(() => repository.getDetail('b'))
        .thenAnswer((_) async => _detail.copyWith(slug: 'b', name: 'B'));

    final a = await container.read(productDetailProvider('a').future);
    final b = await container.read(productDetailProvider('b').future);

    expect(a.name, 'A');
    expect(b.name, 'B');
  });

  test('a failed fetch surfaces as an error, not an empty product',
      () async {
    final container = makeContainer();
    when(() => repository.getDetail('missing'))
        .thenAnswer((_) async => throw const NotFoundException());

    await expectLater(
      container.read(productDetailProvider('missing').future),
      throwsA(isA<NotFoundException>()),
    );
  });
}
