import 'dart:async';
import 'dart:io';

/// Service to check network connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  static const String _googleDotCom = "8.8.8.8"; // Google DNS
  static const Duration _timeout = Duration(seconds: 3);

  late StreamController<bool> _connectionStatusController;
  bool _isConnected = true;
  late Timer _checkTimer;

  ConnectivityService._internal() {
    _connectionStatusController = StreamController<bool>.broadcast();
  }

  factory ConnectivityService() {
    return _instance;
  }

  /// Get stream of connectivity status changes
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  /// Check current connectivity status
  bool get isConnected => _isConnected;

  /// Initialize connectivity monitoring
  /// PERF_DECISION: checkInterval defaults to 30s (instead of 5s) to reduce battery drain
  /// while still being responsive to connectivity changes
  void initialize({Duration checkInterval = const Duration(seconds: 30)}) {
    _checkConnectivity();
    _checkTimer = Timer.periodic(checkInterval, (_) => _checkConnectivity());
  }

  /// Dispose resources
  void dispose() {
    _checkTimer.cancel();
    _connectionStatusController.close();
  }

  /// Check connectivity by attempting to resolve a known DNS
  Future<bool> _checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup(_googleDotCom,
        type: InternetAddressType.IPv4,
      ).timeout(
        _timeout,
        onTimeout: () => throw SocketException('No internet'),
      );

      final newStatus = result.isNotEmpty && result[0].rawAddress.isNotEmpty;

      if (_isConnected != newStatus) {
        _isConnected = newStatus;
        _connectionStatusController.add(_isConnected);
      }

      return _isConnected;
    } on SocketException catch (_) {
      if (_isConnected != false) {
        _isConnected = false;
        _connectionStatusController.add(false);
      }
      return false;
    } catch (_) {
      if (_isConnected != false) {
        _isConnected = false;
        _connectionStatusController.add(false);
      }
      return false;
    }
  }

  /// Manual check for connectivity
  Future<bool> checkConnectivity() => _checkConnectivity();
}

/// Global instance
final connectivityService = ConnectivityService();


