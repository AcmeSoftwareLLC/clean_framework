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
  final json = {'foo': 'bar'};

  setUpAll(() {
    firebaseClient = FirebaseClientFake(json);
    
  });

  tearDownAll(() {
    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch id request', () async {
    gateWay = WatcherGatewayFake();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);
        
    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(json));
  });

  test('FirebaseExternalInterface watch all request', () async {
    gateWay = WatcherGatewayFake();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result =
        await gateWay.transport(FirebaseWatchAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(json));

    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface read id request', () async {
    gateWay = GatewayFake();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseReadIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));
  });

  test('FirebaseExternalInterface read all request', () async {
    final result =
        await gateWay.transport(FirebaseReadAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));
  });
}
