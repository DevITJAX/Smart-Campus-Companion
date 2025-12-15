import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility class to check network connectivity
class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  /// Check if device is connected to the internet
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}
