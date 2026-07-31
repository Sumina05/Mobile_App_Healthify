import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/features/analysis/domain/product_analysis.dart';

void main() {
  group('ProductAnalysis.fromJson', () {
    test('parses the full backend payload', () {
      final json = {
        'id': 'a1',
        'productName': 'Harsh Cleanser X',
        'brand': 'TestBrand',
        'ingredientNames': ['Niacinamide', 'Fragrance'],
        'score': 48,
        'verdict': 'poor',
        'safetyRating': 'high_risk',
        'summary': '1 beneficial, 2 to watch, 2 warnings across 4 ingredients.',
        'recommendationReason': 'Scored for your sensitive skin profile.',
        'aiExplanation': 'This product scored 48/100.',
        'warnings': ['Fragrance matches an allergy in your profile.'],
        'breakdown': [
          {
            'name': 'Niacinamide',
            'matched': true,
            'status': 'good',
            'reason': 'well-tolerated ingredient.',
            'ingredientId': 'i1',
          },
          {
            'name': 'Unicornium',
            'matched': false,
            'status': 'neutral',
            'reason': 'Not in our database yet — treated as neutral.',
            'ingredientId': null,
          },
        ],
        'alternatives': [
          {
            'productId': 'p1',
            'name': 'CeraVe Moisturizing Cream',
            'brand': 'CeraVe',
            'category': 'Moisturizer',
            'matchPercent': 88,
          },
        ],
        'goodCount': 1,
        'watchCount': 2,
        'matchedCount': 3,
        'favorite': false,
        'createdAt': '2026-07-23T10:00:00.000Z',
      };

      final analysis = ProductAnalysis.fromJson(json);
      expect(analysis.score, 48);
      expect(analysis.safetyRating, 'high_risk');
      expect(analysis.breakdown, hasLength(2));
      expect(analysis.breakdown.first.status, 'good');
      expect(analysis.breakdown.last.matched, isFalse);
      expect(analysis.alternatives.single.matchPercent, 88);
      expect(analysis.warnings.single, contains('allergy'));
    });
  });
}
