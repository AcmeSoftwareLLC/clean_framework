enum ConnectivityStatus { online, offline }

typedef ConnectivityListener = void Function(ConnectivityStatus status);

abstract class Connectivity {
  Future<ConnectivityStatus> getConnectivityStatus();
  void registerConnectivityChangeListener(ConnectivityListener listener);
}
