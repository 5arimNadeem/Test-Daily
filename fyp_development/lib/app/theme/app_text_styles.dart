import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Google Fonts–based text theme for Test Daily.
/// Inter is chosen for excellent legibility in technical reading contexts.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme get lightTextTheme =>
      GoogleFonts.interTextTheme(ThemeData.light().textTheme);

  static TextTheme get darkTextTheme =>
      GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

  /// Card headline (feed item title)
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Source / publisher label — use with copyWith(color: colorScheme.onSurfaceVariant)
  static TextStyle get sourceLabel => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      );

  /// Category chip / tag text
  static TextStyle get categoryTag => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  /// Chat bubble text
  static TextStyle get chatBubble => GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
      );

  /// Timestamp / date label — use with copyWith(color: colorScheme.onSurfaceVariant)
  static TextStyle get timestamp => GoogleFonts.inter(
        fontSize: 11,
      );
}
