import 'package:intl/intl.dart';

/// Date presentation shared by every feature, so timestamps read the same
/// way on the dashboard, in history, and in the compare picker.
abstract final class AppDateFormat {
  static final DateFormat _sameYear = DateFormat('d MMM');
  static final DateFormat _otherYear = DateFormat('d MMM yyyy');
  static final DateFormat _full = DateFormat('d MMMM yyyy, h:mm a');

  /// Short, human timestamp for list tiles: `Just now`, `4h ago`,
  /// `Yesterday`, `12 Mar`, `12 Mar 2025`.
  ///
  /// [now] is injectable so tests do not depend on the wall clock.
  static String relative(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final local = date.toLocal();
    final elapsed = reference.difference(local);

    if (elapsed.isNegative) return _absolute(local, reference);
    if (elapsed.inMinutes < 1) return 'Just now';
    if (elapsed.inMinutes < 60) return '${elapsed.inMinutes}m ago';
    if (elapsed.inHours < 24) return '${elapsed.inHours}h ago';

    final startOfToday = DateTime(reference.year, reference.month, reference.day);
    final startOfDate = DateTime(local.year, local.month, local.day);
    final daysApart = startOfToday.difference(startOfDate).inDays;
    if (daysApart == 1) return 'Yesterday';
    if (daysApart < 7) return '${daysApart}d ago';

    return _absolute(local, reference);
  }

  /// Unambiguous timestamp for detail screens.
  static String full(DateTime date) => _full.format(date.toLocal());

  static String _absolute(DateTime local, DateTime reference) =>
      local.year == reference.year
          ? _sameYear.format(local)
          : _otherYear.format(local);
}
