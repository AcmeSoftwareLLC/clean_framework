import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/tests/gateway_fake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final context = ProvidersContext();
late GatewayProvider<WatcherGateway> gatewayProvider;

void main() {
  late FirebaseClientFake firebaseClient;
  final json = {'foo': 'bar'};
  late GatewayProvider gatewayProvider;
  final ProvidersContext context = ProvidersContext();

  setUpAll(() {
    firebaseClient = FirebaseClientFake(json);
  });

  tearDownAll(() {
    firebaseClient.dispose();
  });

  test('FirebaseExternalInterface watch id request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseWatchIdRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));

    //TODO Find out why this verify doesn't work
    // verify(() =>
    //     firebaseClient.watch(path: any(named: 'path'), id: any(named: 'id')));

    await gateWay.hasYielded.future;
    expect(gateWay.successResponse, FirebaseSuccessResponse(json));
  });

  test('FirebaseExternalInterface watch all request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseReadAllRequest, FirebaseSuccessResponse>();
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
    final gateWay =
        WatcherGatewayFake<FirebaseReadAllRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseReadIdRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));
  });

  test('FirebaseExternalInterface read all request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseReadAllRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result =
        await gateWay.transport(FirebaseReadAllRequest(path: 'fake path'));
    expect(result.isRight, isTrue);
    expect(result.right, FirebaseSuccessResponse(json));
  });

  test('FirebaseExternalInterface write request', () async {
    final gateWay =
        WatcherGatewayFake<FirebaseWriteRequest, FirebaseSuccessResponse>();
    FirebaseExternalInterface(
        firebaseClient: firebaseClient, gatewayConnections: [() => gateWay]);

    final result = await gateWay
        .transport(FirebaseWriteRequest(path: 'fake path', id: 'foo'));
    expect(result.isRight, isTrue);
    FirebaseSuccessResponse resJson = result.fold(
      (_) => throw StateError('should be a success'),
      (res) => res,
    );
    expect(resJson.json, json);
  });
}
