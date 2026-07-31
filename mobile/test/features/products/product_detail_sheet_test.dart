import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthify_mobile/core/theme/app_theme.dart';
import 'package:healthify_mobile/core/widgets/gradient_button.dart';
import 'package:healthify_mobile/features/products/data/products_repository.dart';
import 'package:healthify_mobile/features/products/domain/product.dart';
import 'package:healthify_mobile/features/products/presentation/widgets/product_detail_sheet.dart';
import 'package:mocktail/mocktail.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

const _summary = CatalogProduct(
  id: 'web-id-002',
  slug: 'cetaphil-gentle-skin-cleanser',
  name: 'Gentle Skin Cleanser',
  brand: 'Cetaphil',
  category: 'Cleanser',
);

const _fullDetail = ProductDetail(
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
  benefits: ['Gentle cleansing'],
  sideEffects: [],
);

Future<void> pumpSheet(
  WidgetTester tester,
  MockProductsRepository repository, {
  required void Function(BuildContext) open,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [productsRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp(
        theme: AppTheme.dark(),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => open(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pump(); // Opens the sheet.
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late MockProductsRepository repository;

  setUp(() {
    repository = MockProductsRepository();
  });

  group('a search/catalogue result (fetched by slug)', () {
    testWidgets(
        'shows a named loading state, then the full ingredient list and an '
        'enabled Analyze button once the fetch completes — this is the bug: '
        'the summary alone never had ingredients', (tester) async {
      when(() => repository.getDetail('cetaphil-gentle-skin-cleanser'))
          .thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return _fullDetail;
      });

      await pumpSheet(
        tester,
        repository,
        open: (context) => showProductDetail(context, _summary),
      );

      // Loading: the summary's own name is shown immediately, with no
      // Analyze button yet — there's nothing to analyze until the fetch
      // resolves.
      expect(find.text('Gentle Skin Cleanser'), findsWidgets);
      expect(find.byType(GradientButton), findsNothing);

      await tester.pumpAndSettle();

      // Loaded: full detail, and Analyze is enabled because ingredients
      // actually arrived. The sheet's content is longer than the test
      // viewport, so scroll the button into view the way a user would.
      expect(find.textContaining('Ingredients (3)'), findsOneWidget);
      expect(find.text('Aqua'), findsOneWidget);
      expect(find.text('A soap-free, low-lather cleanser.'), findsOneWidget);
      await tester.scrollUntilVisible(find.byType(GradientButton), 300);
      final button =
          tester.widget<GradientButton>(find.byType(GradientButton));
      expect(button.onPressed, isNotNull);
    });

    testWidgets(
        'a failed fetch shows an error with retry — not the analysis '
        "button, which needs data that never arrived", (tester) async {
      when(() => repository.getDetail('cetaphil-gentle-skin-cleanser'))
          .thenAnswer((_) async => throw Exception('offline'));

      await pumpSheet(
        tester,
        repository,
        open: (context) => showProductDetail(context, _summary),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Could not load'), findsOneWidget);
      // StatusView's own retry action is a GradientButton labelled "Try
      // Again" — a real button must exist, just not one saying "Analyze".
      expect(find.text('Analyze for My Skin'), findsNothing);
      expect(find.text('Try Again'), findsOneWidget);
    });
  });

  group('a barcode-scanned product (already complete)', () {
    testWidgets('shows full detail immediately, with no fetch', (tester) async {
      const barcodeProduct = BarcodeProduct(
        id: 'web-id-003',
        slug: 'cerave-foaming-facial-cleanser',
        barcode: '3337875597197',
        name: 'Foaming Facial Cleanser',
        brand: 'CeraVe',
        category: 'Cleanser',
        description: 'A gel-to-foam wash.',
        ingredientNames: ['Aqua', 'Niacinamide'],
        safetyScore: 92,
        safetyBand: 'excellent',
        source: 'catalog',
      );

      await pumpSheet(
        tester,
        repository,
        open: (context) =>
            showProductDetailFromBarcode(context, barcodeProduct),
      );
      await tester.pump();

      expect(find.textContaining('Ingredients (2)'), findsOneWidget);
      expect(find.text('Niacinamide'), findsOneWidget);
      final button =
          tester.widget<GradientButton>(find.byType(GradientButton));
      expect(button.onPressed, isNotNull);
      // No repository call — the data was already complete.
      verifyNever(() => repository.getDetail(any()));
    });
  });
}
