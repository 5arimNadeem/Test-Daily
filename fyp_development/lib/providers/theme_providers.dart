import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls the app-wide theme mode (light / dark / system).
/// Persisting this preference to shared_prefs is a v2 enhancement.
final themeModeProvider = StateProvider<ThemeMode>(
  (ref) => ThemeMode.system,
);
