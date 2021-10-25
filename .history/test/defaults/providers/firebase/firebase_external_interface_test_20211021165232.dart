import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late GatewayProvider<WatcherGateway> gatewayProvider;

void main() {
  test('Firebase External Interface with watch', () async {
    final firebaseClient = FirebaseClientFake({
      
    });
    final gateWay = WatcherGatewayFake();
    //gatewayProvider = GatewayProvider((_) => gateWay);

    FirebaseExternalInterface(firebaseClient: firebaseClient, gatewayConnections: [
      () => gateWay
    ]);

    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, isA<SuccessResponse>());

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, TestFirebaseSuccessResponse('watchId'));
  });

  // test('Firebase External Interface with watchAll', () async {
  //   final fireStore = FireStoreFake<StoreModelFake>(StoreModelFake('watchAll'));
  //   final gateWay = WatcherGatewayFake();
  //   gatewayProvider = GatewayProvider((_) => gateWay);

  //   TestFirebaseWatchExternalInterface(fireStore);

  //   final result =
  //       await gateWay.transport(FirebaseWatchAllRequest(path: 'fake path'));
  //   expect(result.isRight, isTrue);
  //   expect(result.right, isA<SuccessResponse>());

  //   await gateWay.hasYielded.future;
  //   expect(gateWay.successResponse, TestFirebaseSuccessResponse('watchAll'));
  // });
}

class TestFirebase

class TestFirebaseSuccessResponse extends FirebaseSuccessResponse {
  final String data;

  TestFirebaseSuccessResponse(this.data);
}
