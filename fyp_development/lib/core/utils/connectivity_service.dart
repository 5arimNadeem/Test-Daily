import 'package:connectivity_plus/connectivity_plus.dart';

/// Wraps connectivity_plus with a simple API for the splash screen
/// and other connectivity checks throughout the app.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  /// Returns true if the device has any active network connection.
  /// Note: This indicates a network interface is available, not necessarily
  /// that internet is reachable.
  Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  /// Stream of connectivity changes — useful for reactive UI updates.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
