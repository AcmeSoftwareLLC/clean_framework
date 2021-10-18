import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/providers/gateway_provider.dart';
import 'package:either_dart/src/either.dart';

import 'fire_store.dart';
import 'firebase_requests.dart';
import 'firebase_responses.dart';

abstract class FirebaseWatchExternalInterface<M extends StoreModel,
        R extends FirebaseRequest, P extends FirebaseSuccessResponse>
    extends WatcherExternalInterface<R, SuccessResponse> {
  final FireStore _fireStore;

  FirebaseWatchExternalInterface(
      {required ProvidersContext context,
      required GatewayProvider<WatcherGateway> provider,
      FireStore? fireStore})
      : _fireStore = fireStore ?? FireStore(),
        super([() => provider.getGateway(context)]);

  @override
  Future<Either<FailureResponse, SuccessResponse>> onTransport(
      R request, Function(P) yieldResponse) async {
    if (request is FirebaseWatchAllRequest) {
      return _withFirebaseWatchAllRequest(request, yieldResponse);
    }
    // else if (request is FirebaseWatchIdRequest) {
    //   return _withFirebaseWatchIdRequest(request, yieldResponse);
    // }
    return Left(FailureResponse());
  }

  Future<Either<FailureResponse, SuccessResponse>> _withFirebaseWatchAllRequest(
      R request, Function(P) yieldResponse) async {
    final featureStream = _fireStore.watchAll(
        path: request.path, converter: (data) => parse(data));
    featureStream.listen((modelList) {
      // modelList.forEach((model) {
      yieldResponse(getResponse(modelList));
      // });
    });
    return Right(SuccessResponse());
  }

  // Future<Either<FailureResponse, SuccessResponse>> _withFirebaseWatchIdRequest(
  //     FirebaseWatchIdRequest request, Function(P) yieldResponse) async {
  //   final featureStream = _fireStore.watch(
  //       path: request.path, id: request.id, converter: (data) => parse(data));
  //   featureStream.listen((model) {
  //     yieldResponse(getResponse(model));
  //   });
  //   return Right(SuccessResponse());
  // }

  M parse(Map<String, dynamic> json);
  P getResponse(List<M> storeModel);
}
