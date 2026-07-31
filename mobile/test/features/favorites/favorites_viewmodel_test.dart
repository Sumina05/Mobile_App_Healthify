import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/features/favorites/data/favorites_repository.dart';
import 'package:healthify_mobile/features/favorites/presentation/viewmodels/favorites_viewmodel.dart';
import 'package:healthify_mobile/features/ingredients/domain/ingredient.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

const _niacinamide = Ingredient(
  id: 'i1',
  name: 'Niacinamide',
  tagline: 'The multitasking barrier builder',
  purpose: 'Barrier support',
  description: 'A well-tolerated active.',
  safetyRating: 'safe',
);

const _item = FavoriteItem(id: 'f1', ingredient: _niacinamide);

void main() {
  late MockFavoritesRepository repository;

  ProviderContainer makeContainer() {
    repository = MockFavoritesRepository();
    final container = ProviderContainer(
      overrides: [
        favoritesRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads favorites from the repository', () async {
    final container = makeContainer();
    when(() => repository.fetchAll()).thenAnswer((_) async => [_item]);

    final items =
        await container.read(favoritesViewModelProvider.future);
    expect(items, hasLength(1));
    expect(items.first.ingredient.name, 'Niacinamide');
  });

  test('remove is optimistic and calls the API', () async {
    final container = makeContainer();
    when(() => repository.fetchAll()).thenAnswer((_) async => [_item]);
    when(() => repository.remove('f1')).thenAnswer((_) async {});

    await container.read(favoritesViewModelProvider.future);
    await container
        .read(favoritesViewModelProvider.notifier)
        .remove(_item);

    expect(container.read(favoritesViewModelProvider).value, isEmpty);
    verify(() => repository.remove('f1')).called(1);
  });

  test('remove rolls back when the API call fails', () async {
    final container = makeContainer();
    when(() => repository.fetchAll()).thenAnswer((_) async => [_item]);
    when(() => repository.remove('f1')).thenThrow(Exception('offline'));

    await container.read(favoritesViewModelProvider.future);
    await expectLater(
      container.read(favoritesViewModelProvider.notifier).remove(_item),
      throwsException,
    );

    expect(
      container.read(favoritesViewModelProvider).value,
      hasLength(1),
    );
  });
}
