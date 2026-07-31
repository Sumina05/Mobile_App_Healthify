import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Plus Jakarta Sans for display/headings, Inter for body/labels.
abstract final class AppTypography {
  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    final display = GoogleFonts.plusJakartaSansTextTheme();
    final body = GoogleFonts.interTextTheme();

    return TextTheme(
      displayLarge: display.displayLarge!
          .copyWith(color: primary, fontWeight: FontWeight.w800),
      displayMedium: display.displayMedium!
          .copyWith(color: primary, fontWeight: FontWeight.w800),
      displaySmall: display.displaySmall!
          .copyWith(color: primary, fontWeight: FontWeight.w700),
      headlineLarge: display.headlineLarge!
          .copyWith(color: primary, fontWeight: FontWeight.w700),
      headlineMedium: display.headlineMedium!
          .copyWith(color: primary, fontWeight: FontWeight.w700),
      headlineSmall: display.headlineSmall!
          .copyWith(color: primary, fontWeight: FontWeight.w700),
      titleLarge: display.titleLarge!
          .copyWith(color: primary, fontWeight: FontWeight.w600),
      titleMedium: display.titleMedium!
          .copyWith(color: primary, fontWeight: FontWeight.w600),
      titleSmall: display.titleSmall!
          .copyWith(color: primary, fontWeight: FontWeight.w600),
      bodyLarge: body.bodyLarge!.copyWith(color: primary, height: 1.5),
      bodyMedium: body.bodyMedium!.copyWith(color: secondary, height: 1.5),
      bodySmall: body.bodySmall!.copyWith(color: secondary, height: 1.4),
      labelLarge: body.labelLarge!
          .copyWith(color: primary, fontWeight: FontWeight.w600),
      labelMedium: body.labelMedium!
          .copyWith(color: secondary, fontWeight: FontWeight.w500),
      labelSmall: body.labelSmall!
          .copyWith(color: secondary, fontWeight: FontWeight.w500, letterSpacing: 0.4),
    );
  }
}
