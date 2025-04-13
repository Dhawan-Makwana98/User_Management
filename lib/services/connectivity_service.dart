import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  StreamSubscription<ConnectivityResult>? _subscription;

  void monitorConnectivity(Function(ConnectivityResult) callback) {
    _subscription = Connectivity()
            .onConnectivityChanged
            .listen(callback as void Function(List<ConnectivityResult> event)?)
        as StreamSubscription<ConnectivityResult>?;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
