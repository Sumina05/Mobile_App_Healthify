import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/storage/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<PreferencesService> makeService() async {
    SharedPreferences.setMockInitialValues({});
    return PreferencesService(await SharedPreferences.getInstance());
  }

  group('search history', () {
    test('stores most-recent-first and de-duplicates case-insensitively',
        () async {
      final service = await makeService();
      await service.addSearchTerm('retinol');
      await service.addSearchTerm('niacinamide');
      await service.addSearchTerm('Retinol');

      expect(service.searchHistory, ['Retinol', 'niacinamide']);
    });

    test('ignores blank terms and caps the list at 8', () async {
      final service = await makeService();
      await service.addSearchTerm('   ');
      for (var i = 1; i <= 10; i++) {
        await service.addSearchTerm('term$i');
      }
      expect(service.searchHistory, hasLength(8));
      expect(service.searchHistory.first, 'term10');
      expect(service.searchHistory, isNot(contains('term1')));
    });

    test('clear empties the history', () async {
      final service = await makeService();
      await service.addSearchTerm('ceramides');
      await service.clearSearchHistory();
      expect(service.searchHistory, isEmpty);
    });
  });
}
