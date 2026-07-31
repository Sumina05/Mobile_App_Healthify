import 'package:flutter/material.dart';

/// Healthify brand palette — dark-first, mint/cyan accents on deep navy.
abstract final class AppColors {
  // Brand accents
  static const Color mint = Color(0xFF30E3A2);
  static const Color cyan = Color(0xFF22D3EE);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color indigo = Color(0xFF6366F1);

  // Dark surfaces
  static const Color darkBackground = Color(0xFF070C14);
  static const Color darkSurface = Color(0xFF0D1520);
  static const Color darkSurfaceHigh = Color(0xFF111C2A);
  static const Color darkSurfaceHighest = Color(0xFF162334);
  static const Color darkOutline = Color(0x2E94A3B8);

  // Light surfaces
  static const Color lightBackground = Color(0xFFF6F9FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFEDF3F7);
  static const Color lightSurfaceHighest = Color(0xFFE2EBF2);
  static const Color lightOutline = Color(0x33475569);

  // Text
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Semantic
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFF87171);
  static const Color info = Color(0xFF60A5FA);

  /// Foreground used on top of the mint primary (buttons, chips).
  static const Color onMint = Color(0xFF04281C);
}
