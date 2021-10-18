import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:test/test.dart';

void main() {
  test('DefaultConnectivity get status', () {
    var conn = AlwaysOnlineConnectivity();
    expectLater(
        conn.getConnectivityStatus(), completion(ConnectivityStatus.online));

    bool connectivityChanged = false;
    conn.registerConnectivityChangeListener((ConnectivityStatus newStatus) {
      connectivityChanged = true;
    });

    expectLater(
        Future.delayed(Duration(milliseconds: 100), () {
          return connectivityChanged;
        }),
        completion(isTrue));
  });
}
