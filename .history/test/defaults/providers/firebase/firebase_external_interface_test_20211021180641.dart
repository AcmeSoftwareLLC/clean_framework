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
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);
  });

  tearDownAll(() {
    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch id request', () async {
    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, isA<SuccessResponse>());

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(jsonContent));
  });

  test('FirebaseExternalInterface watch all request', () async {
    final result =
        await gateWay.transport(FirebaseWatchAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, isA<SuccessResponse>());

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(jsonContent));

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface read id request', () async {
    final result = await gateWay
        .transport(FirebaseReadIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(jsonContent));
  });
}
