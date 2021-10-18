import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';

final context = ProvidersContext();
late GatewayProvider<WatcherGateway> gatewayProvider;

void main() {
  // test('Firebase External Interface with watch', () async {
  //   final fireStore = FireStoreFake<StoreModelFake>(StoreModelFake('watchId'));
  //   final gateWay = WatcherGatewayFake();
  //   gatewayProvider = GatewayProvider((_) => gateWay);

  //   TestFirebaseWatchExternalInterface(fireStore);

  //   final result = await gateWay
  //       .transport(FirebaseWatchIdRequest(path: 'fake path', id: 'foo'));
  //   expect(result.isRight, isTrue);
  //   expect(result.right, isA<SuccessResponse>());

  //   await gateWay.hasYielded.future;
  //   expect(gateWay.successResponse, TestFirebaseSuccessResponse('watchId'));
  // });

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
//}

// class TestFirebaseWatchExternalInterface
//     extends FirebaseWatcherExternalInterface {
//   TestFirebaseWatchExternalInterface(FireStore fireStore)
//       : super(
//             context: context, provider: gatewayProvider, fireStore: fireStore);

//   @override
//   FirebaseSuccessResponse getResponse(StoreModel storeModel) {
//     if (storeModel is StoreModelFake)
//       return TestFirebaseSuccessResponse(storeModel.data);
//     else
//       return TestFirebaseSuccessResponse('should not happen');
//   }

//   @override
//   StoreModel parse(Map<String, dynamic> json) {
//     return StoreModelFake('');
//   }
// }

// class TestFirebaseSuccessResponse extends FirebaseSuccessResponse {
//   final String data;

//   TestFirebaseSuccessResponse(this.data);
}
