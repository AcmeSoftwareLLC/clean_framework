import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';

import 'firebase_client.dart';
import 'firebase_requests.dart';
import 'firebase_responses.dart';

class FirebaseExternalInterface
    extends DirectExternalInterface<FirebaseRequest, SuccessResponse> {
  final FirebaseClient _client;

  FirebaseExternalInterface(
      {required List<GatewayConnection<Gateway>> gatewayConnections,
      FirebaseClient? firebaseClient})
      : _client = firebaseClient ?? FirebaseClient(),
        super(gatewayConnections);

  @override
  Future<Either<FailureResponse, FirebaseSuccessResponse>> onTransport(
      covariant FirebaseRequest request) async {
    if (request is FirebaseReadIdRequest) {
      return _withFirebaseReadIdRequest(request);
    } else if (request is FirebaseReadAllRequest) {
      return _withFirebaseReadAllRequest(request);
    } else if (request is FirebaseWriteRequest) {
      return _withFirebaseWriteRequest(request);
    } else if (request is FirebaseUpdateRequest) {
      _withFirebaseUpdateRequest(request);
    } else if (request is FirebaseDeleteRequest) {
      _withFirebaseDeleteRequest(request);
    }
    return Left(RequestNotRecognizedFailureResponse());
  }

  Future<Either<FailureResponse, FirebaseSuccessResponse>>
      _withFirebaseReadIdRequest(FirebaseReadIdRequest request) async {
    final content = await _client.read(path: request.path, id: request.id);
    if (content.isEmpty) return Left(NoContentFirebaseFailureResponse());
    return Right(FirebaseSuccessResponse(content));
  }

  Future<Either<FailureResponse, FirebaseSuccessResponse>>
      _withFirebaseReadAllRequest(FirebaseReadAllRequest request) async {
    final content = await _client.readAll(path: request.path);
    if (content.isEmpty) return Left(NoContentFirebaseFailureResponse());
    return Right(FirebaseSuccessResponse(content));
  }

  Future<Either<FailureResponse, FirebaseSuccessResponse>>
      _withFirebaseWriteRequest(FirebaseWriteRequest request) async {
    final id = await _client.write(
        path: request.path, id: request.id, content: request.toJson());
    if (id.isEmpty) return Left(WriteFirebaseFailureResponse());
    return Right(FirebaseSuccessResponse({'id': id}));
  }

  Future<Either<FailureResponse, FirebaseSuccessResponse>>
      _withFirebaseUpdateRequest(FirebaseUpdateRequest request) async {
    await _client.update(
        path: request.path, id: request.id, content: request.toJson());
    return Right(FirebaseSuccessResponse({}));
  }

  Future<Either<FailureResponse, FirebaseSuccessResponse>>
      _withFirebaseDeleteRequest(FirebaseDeleteRequest request) async {
    await _client.delete(path: request.path, id: request.id);
    return Right(FirebaseSuccessResponse({}));
  }
}

class FirebaseWatcherExternalInterface
    extends WatcherExternalInterface<FirebaseRequest, SuccessResponse> {
  final FirebaseClient _client;

  FirebaseWatcherExternalInterface(
      {required List<GatewayConnection<WatcherGateway>> gatewayConnections,
      FirebaseClient? firebaseClient})
      : _client = firebaseClient ?? FirebaseClient(),
        super(gatewayConnections);

  @override
  Future<Either<FailureResponse, SuccessResponse>> onTransport(
      covariant FirebaseRequest request,
      Function(FirebaseSuccessResponse) yieldResponse) async {
    if (request is FirebaseWatchIdRequest) {
      return _withFirebaseWatchIdRequest(request, yieldResponse);
    } else if (request is FirebaseWatchAllRequest) {
      return _withFirebaseWatchAllRequest(request, yieldResponse);
    }
    return Left(RequestNotRecognizedFailureResponse());
  }

  Future<Either<FailureResponse, SuccessResponse>> _withFirebaseWatchIdRequest(
      FirebaseWatchIdRequest request,
      Function(FirebaseSuccessResponse) yieldResponse) async {
    final featureStream = _client.watch(path: request.path, id: request.id);
    featureStream.listen((model) {
      yieldResponse(FirebaseSuccessResponse(model));
    });

    return Right(SuccessResponse());
  }

  Future<Either<FailureResponse, SuccessResponse>> _withFirebaseWatchAllRequest(
      FirebaseWatchAllRequest request,
      Function(FirebaseSuccessResponse) yieldResponse) async {
    final featureStream = _client.watchAll(path: request.path);
    featureStream.listen((model) {
      yieldResponse(FirebaseSuccessResponse(model));
    });

    return Right(SuccessResponse());
  }
}
