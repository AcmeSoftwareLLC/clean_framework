import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();
late GatewayProvider<WatcherGateway> gatewayProvider;

void main() {
  late FirebaseClientFake firebaseClient;
  late WatcherGatewayFake gateWay;
  final jsonContent = {
    'foo': 'bar',
  };

  setUpAll(() {
    firebaseClient = FirebaseClientFake(jsonContent);
    gateWay = WatcherGatewayFake();
  });

  tearDownAll(() {
    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch id request', () async {
    final jsonContent = {
      'foo': 'bar',
    };
    final firebaseClient = FirebaseClientFake(jsonContent);
    final gateWay = WatcherGatewayFake();

    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, isA<SuccessResponse>());

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(jsonContent));

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch all request', () async {
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, isA<SuccessResponse>());

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(jsonContent));

    firebaseClient.dispose();
  });
}
