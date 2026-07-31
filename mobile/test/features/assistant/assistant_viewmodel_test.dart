import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/network/dio_client.dart';
import 'package:healthify_mobile/features/assistant/presentation/viewmodels/assistant_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

Response<Map<String, dynamic>> _reply(
  String text, {
  Map<String, dynamic>? ingredient,
}) =>
    Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: '/chat'),
      statusCode: 200,
      data: {
        'data': {'reply': text, 'ingredient': ingredient},
      },
    );

void main() {
  late MockDio dio;

  setUpAll(() {
    registerFallbackValue(<String, dynamic>{});
  });

  ProviderContainer makeContainer() {
    dio = MockDio();
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [dioProvider.overrideWithValue(dio)],
    );
    addTearDown(container.dispose);
    return container;
  }

  void stubPost(Response<Map<String, dynamic>> response) {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => response);
  }

  test('opens with a greeting', () {
    final container = makeContainer();
    final messages = container.read(assistantViewModelProvider(null));

    expect(messages, hasLength(1));
    expect(messages.single.isUser, isFalse);
    expect(messages.single.text, contains('niacinamide'));
  });

  test('an analysis-scoped chat opens with product-specific copy', () {
    final container = makeContainer();
    final messages = container.read(assistantViewModelProvider('a1'));

    expect(messages.single.text, contains('this product'));
  });

  test('sending appends the question and the reply', () async {
    final container = makeContainer();
    stubPost(_reply('Niacinamide calms redness.'));

    await container
        .read(assistantViewModelProvider(null).notifier)
        .send('What is niacinamide?');

    final messages = container.read(assistantViewModelProvider(null));
    expect(messages, hasLength(3));
    expect(messages[1].isUser, isTrue);
    expect(messages[1].text, 'What is niacinamide?');
    expect(messages[2].isUser, isFalse);
    expect(messages[2].text, 'Niacinamide calms redness.');
    // The pending placeholder must not survive the reply.
    expect(messages.any((m) => m.pending), isFalse);
  });

  test('blank input is ignored', () async {
    final container = makeContainer();

    await container
        .read(assistantViewModelProvider(null).notifier)
        .send('   ');

    expect(container.read(assistantViewModelProvider(null)), hasLength(1));
    verifyNever(
      () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
    );
  });

  test('a matched ingredient is attached to the reply', () async {
    final container = makeContainer();
    stubPost(_reply('Niacinamide is well tolerated.', ingredient: {
      'id': 'i1',
      'name': 'Niacinamide',
      'tagline': 'Barrier builder',
      'purpose': 'Barrier support',
      'description': 'A gentle active.',
      'safetyRating': 'safe',
    }));

    await container
        .read(assistantViewModelProvider(null).notifier)
        .send('niacinamide');

    final last = container.read(assistantViewModelProvider(null)).last;
    expect(last.ingredient?.name, 'Niacinamide');
  });

  test('a network failure surfaces its own message, flagged as an error',
      () async {
    final container = makeContainer();
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
      (_) async => throw DioException(
        requestOptions: RequestOptions(path: '/chat'),
        type: DioExceptionType.connectionError,
      ),
    );

    await container
        .read(assistantViewModelProvider(null).notifier)
        .send('hello');

    final last = container.read(assistantViewModelProvider(null)).last;
    expect(last.isError, isTrue);
    expect(last.text, contains('No internet connection'));
    expect(container.read(assistantViewModelProvider(null)).any((m) => m.pending),
        isFalse);
  });

  test('a server failure surfaces the API message rather than a generic one',
      () async {
    final container = makeContainer();
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer(
      (_) async => throw DioException(
        requestOptions: RequestOptions(path: '/chat'),
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/chat'),
          statusCode: 429,
          data: {'message': 'Too many requests. Try again in a minute.'},
        ),
      ),
    );

    await container
        .read(assistantViewModelProvider(null).notifier)
        .send('hello');

    final last = container.read(assistantViewModelProvider(null)).last;
    expect(last.isError, isTrue);
    expect(last.text, 'Too many requests. Try again in a minute.');
  });

  test('a second send is ignored while one is in flight', () async {
    final container = makeContainer();
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')))
        .thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 80));
      return _reply('done');
    });

    final viewModel = container.read(assistantViewModelProvider(null).notifier);
    final first = viewModel.send('one');
    await viewModel.send('two'); // returns immediately, ignored
    await first;

    final messages = container.read(assistantViewModelProvider(null));
    expect(messages.where((m) => m.isUser).map((m) => m.text), ['one']);
    verify(
      () => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data')),
    ).called(1);
  });
}
