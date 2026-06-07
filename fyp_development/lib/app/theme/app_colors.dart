import 'package:flutter/material.dart';

/// Brand color constants for Test Daily.
/// The primary seed colour generates the full Material 3 colour scheme.
class AppColors {
  AppColors._();

  /// Primary brand blue — seed for Material 3 ColorScheme
  static const Color primarySeed = Color(0xFF0057D9);

  /// Used for the AI assistant accent elements
  static const Color aiAccent = Color(0xFF00897B);

  /// Bookmark icon active colour
  static const Color bookmarkActive = Color(0xFFFFB300);

  /// Error / rate-limit state
  static const Color error = Color(0xFFB00020);

  /// Category chip background (light mode)
  static const Color chipBackground = Color(0xFFE8F0FE);

  /// Tag pill text on cards
  static const Color tagText = Color(0xFF1565C0);
}
