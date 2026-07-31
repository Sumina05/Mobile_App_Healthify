import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/features/scanner/presentation/viewmodels/scanner_viewmodel.dart';

void main() {
  group('ScannerViewModel.parseIngredients', () {
    test('extracts names after the Ingredients marker', () {
      const text = 'CeraVe Moisturizing Cream\n'
          'INGREDIENTS: Aqua, Glycerin, Niacinamide, Ceramide NP, '
          'Sodium Hyaluronate.';
      final result = ScannerViewModel.parseIngredients(text);

      expect(result, contains('Glycerin'));
      expect(result, contains('Niacinamide'));
      expect(result, contains('Ceramide NP'));
      expect(result, contains('Sodium Hyaluronate'));
      expect(result, isNot(contains('CeraVe Moisturizing Cream')));
    });

    test('handles text without a marker by splitting separators', () {
      const text = 'Aqua, Glycerin; Panthenol • Squalane';
      final result = ScannerViewModel.parseIngredients(text);
      expect(result, ['Aqua', 'Glycerin', 'Panthenol', 'Squalane']);
    });

    test('filters out noise tokens', () {
      const text = 'Ingredients: A1, ##, Niacinamide, x';
      final result = ScannerViewModel.parseIngredients(text);
      expect(result, ['Niacinamide']);
    });
  });
}
