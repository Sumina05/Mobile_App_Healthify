import 'package:flutter_test/flutter_test.dart';
import 'package:healthify_mobile/core/utils/app_date_format.dart';

void main() {
  final now = DateTime(2026, 3, 12, 15, 30);

  group('AppDateFormat.relative', () {
    test('collapses the last minute to "Just now"', () {
      expect(
        AppDateFormat.relative(now.subtract(const Duration(seconds: 20)),
            now: now),
        'Just now',
      );
    });

    test('reports minutes within the hour', () {
      expect(
        AppDateFormat.relative(now.subtract(const Duration(minutes: 42)),
            now: now),
        '42m ago',
      );
    });

    test('reports hours within the day', () {
      expect(
        AppDateFormat.relative(now.subtract(const Duration(hours: 5)),
            now: now),
        '5h ago',
      );
    });

    test('prefers hours over "Yesterday" inside the last 24 hours', () {
      // 16.5h old, but still the previous calendar day.
      expect(
        AppDateFormat.relative(DateTime(2026, 3, 11, 23, 0), now: now),
        '16h ago',
      );
    });

    test('names the previous calendar day "Yesterday" beyond 24 hours', () {
      expect(
        AppDateFormat.relative(DateTime(2026, 3, 11, 9, 0), now: now),
        'Yesterday',
      );
    });

    test('counts whole days up to a week', () {
      expect(
        AppDateFormat.relative(DateTime(2026, 3, 8, 9, 0), now: now),
        '4d ago',
      );
    });

    test('falls back to a day/month date beyond a week', () {
      expect(
        AppDateFormat.relative(DateTime(2026, 2, 20, 9, 0), now: now),
        '20 Feb',
      );
    });

    test('includes the year once the date is in a different year', () {
      expect(
        AppDateFormat.relative(DateTime(2025, 11, 4, 9, 0), now: now),
        '4 Nov 2025',
      );
    });

    test('does not produce negative durations for future timestamps', () {
      expect(
        AppDateFormat.relative(DateTime(2026, 3, 20, 9, 0), now: now),
        '20 Mar',
      );
    });
  });

  test('AppDateFormat.full is unambiguous', () {
    expect(
      AppDateFormat.full(DateTime(2026, 3, 12, 15, 30)),
      '12 March 2026, 3:30 PM',
    );
  });
}
