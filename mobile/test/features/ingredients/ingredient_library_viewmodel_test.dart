import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/features/ingredients/data/ingredients_repository.dart';
import 'package:healthify_mobile/features/ingredients/domain/ingredient.dart';
import 'package:healthify_mobile/features/ingredients/presentation/viewmodels/ingredient_library_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockIngredientsRepository extends Mock implements IngredientsRepository {}

const _niacinamide = Ingredient(
  id: 'i1',
  name: 'Niacinamide',
  tagline: 'The multitasking barrier builder',
  purpose: 'Barrier support',
  description: 'A well-tolerated active.',
  safetyRating: 'safe',
);

const _retinol = Ingredient(
  id: 'i2',
  name: 'Retinol',
  tagline: 'The gold-standard renewer',
  purpose: 'Cell turnover',
  description: 'Potent but irritating.',
  safetyRating: 'caution',
);

const _fragrance = Ingredient(
  id: 'i3',
  name: 'Fragrance',
  tagline: 'A common irritant',
  purpose: 'Scent',
  description: 'Frequent cause of contact dermatitis.',
  safetyRating: 'avoid',
  isCommonAllergen: true,
);

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
  late MockIngredientsRepository repository;

  ProviderContainer makeContainer() {
    repository = MockIngredientsRepository();
    final container = ProviderContainer(
      // Riverpod 3 retries failed providers with backoff; disable it so a
      // failed load settles deterministically instead of retrying forever.
      retry: (_, _) => null,
      overrides: [
        ingredientsRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// Wires up the three calls the initial load fans out to.
  void stubInitialLoad({
    Ingredient? daily = _niacinamide,
    List<Ingredient> recommended = const [_retinol],
    List<Ingredient> all = const [_niacinamide, _retinol, _fragrance],
  }) {
    when(() => repository.ingredientOfTheDay()).thenAnswer((_) async => daily);
    when(() => repository.recommended()).thenAnswer((_) async => recommended);
    when(() => repository.search('')).thenAnswer((_) async => all);
  }

  test('initial load fans out to daily, recommended and browse', () async {
    final container = makeContainer();
    stubInitialLoad();

    final state =
        await container.read(ingredientLibraryViewModelProvider.future);

    expect(state.ingredientOfTheDay?.name, 'Niacinamide');
    expect(state.recommended, hasLength(1));
    expect(state.results, hasLength(3));
    expect(state.showsDiscovery, isTrue);
    verify(() => repository.ingredientOfTheDay()).called(1);
    verify(() => repository.recommended()).called(1);
    verify(() => repository.search('')).called(1);
  });

  test('a missing ingredient of the day does not fail the load', () async {
    final container = makeContainer();
    stubInitialLoad(daily: null);

    final state =
        await container.read(ingredientLibraryViewModelProvider.future);

    expect(state.ingredientOfTheDay, isNull);
    expect(state.results, hasLength(3));
  });

  test('searching hides the discovery rails and swaps in results', () async {
    final container = makeContainer();
    stubInitialLoad();
    when(() => repository.search('retin'))
        .thenAnswer((_) async => [_retinol]);

    await container.read(ingredientLibraryViewModelProvider.future);
    final viewModel =
        container.read(ingredientLibraryViewModelProvider.notifier);

    viewModel.search('retin');
    await waitFor(() =>
        container.read(ingredientLibraryViewModelProvider).value?.isSearching ==
        false);

    final state = container.read(ingredientLibraryViewModelProvider).value!;
    expect(state.query, 'retin');
    expect(state.showsDiscovery, isFalse);
    expect(state.results, [_retinol]);
    expect(state.isSearching, isFalse);
  });

  test('debounce collapses rapid keystrokes into one request', () async {
    final container = makeContainer();
    stubInitialLoad();
    when(() => repository.search(any(that: isNotEmpty)))
        .thenAnswer((_) async => [_retinol]);

    await container.read(ingredientLibraryViewModelProvider.future);
    final viewModel =
        container.read(ingredientLibraryViewModelProvider.notifier);

    viewModel.search('r');
    viewModel.search('re');
    viewModel.search('ret');
    await waitFor(() =>
        container.read(ingredientLibraryViewModelProvider).value?.isSearching ==
        false);

    verify(() => repository.search('ret')).called(1);
    verifyNever(() => repository.search('r'));
    verifyNever(() => repository.search('re'));
  });

  test('a stale response does not overwrite a newer query', () async {
    final container = makeContainer();
    stubInitialLoad();
    when(() => repository.search('slow')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      return [_fragrance];
    });
    when(() => repository.search('fast'))
        .thenAnswer((_) async => [_retinol]);

    await container.read(ingredientLibraryViewModelProvider.future);
    final viewModel =
        container.read(ingredientLibraryViewModelProvider.notifier);

    final stale = viewModel.runSearch('slow');
    viewModel.search('fast');
    await viewModel.runSearch('fast');
    await stale;

    final state = container.read(ingredientLibraryViewModelProvider).value!;
    expect(state.query, 'fast');
    expect(state.results, [_retinol]);
  });

  test('clearing the query restores the discovery rails', () async {
    final container = makeContainer();
    stubInitialLoad();
    when(() => repository.search('retin'))
        .thenAnswer((_) async => [_retinol]);

    await container.read(ingredientLibraryViewModelProvider.future);
    final viewModel =
        container.read(ingredientLibraryViewModelProvider.notifier);

    viewModel.search('retin');
    await waitFor(() =>
        container.read(ingredientLibraryViewModelProvider).value?.query ==
        'retin');
    viewModel.search('');
    await waitFor(() =>
        container.read(ingredientLibraryViewModelProvider).value?.query == '' &&
        container.read(ingredientLibraryViewModelProvider).value?.isSearching ==
            false);

    final state = container.read(ingredientLibraryViewModelProvider).value!;
    expect(state.query, isEmpty);
    expect(state.showsDiscovery, isTrue);
    expect(state.recommended, hasLength(1));
  });

  test('a failed search surfaces as an error state', () async {
    final container = makeContainer();
    stubInitialLoad();
    when(() => repository.search('boom')).thenThrow(Exception('offline'));

    await container.read(ingredientLibraryViewModelProvider.future);
    final viewModel =
        container.read(ingredientLibraryViewModelProvider.notifier);

    viewModel.search('boom');
    await viewModel.runSearch('boom');

    expect(container.read(ingredientLibraryViewModelProvider).hasError, isTrue);
  });
}
