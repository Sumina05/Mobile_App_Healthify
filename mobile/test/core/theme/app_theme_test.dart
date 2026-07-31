import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthify_mobile/core/theme/app_colors.dart';
import 'package:healthify_mobile/core/theme/app_theme.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('AppTheme', () {
    testWidgets('dark theme uses Material 3 with the mint brand primary',
        (tester) async {
      final theme = AppTheme.dark();
      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, AppColors.mint);
      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
    });

    testWidgets('light theme is a distinct, accessible counterpart',
        (tester) async {
      final theme = AppTheme.light();
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, isNot(AppColors.mint));
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
    });

    testWidgets('buttons share the 52dp premium height', (tester) async {
      final style = AppTheme.dark().elevatedButtonTheme.style!;
      expect(style.minimumSize!.resolve({}), const Size.fromHeight(52));
    });
  });
}
