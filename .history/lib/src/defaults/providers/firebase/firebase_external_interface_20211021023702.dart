import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';

import 'firebase_client.dart';
import 'firebase_requests.dart';
import 'firebase_responses.dart';

class FirebaseExternalInterface
    extends ExternalInterface<FirebaseRequest, SuccessResponse> {
  final FirebaseClient _client;

  FirebaseExternalInterface({
    required List<GatewayConnection<Gateway>> gatewayConnections,
    FirebaseClient? firebaseClient,
  })  : _client = firebaseClient ?? FirebaseClient(),
        super(gatewayConnections);

  @override
  void handleRequest() {
    on<FirebaseReadIdRequest>(_withFirebaseReadIdRequest);
    on<FirebaseReadAllRequest>(_withFirebaseReadAllRequest);
    on<FirebaseWriteRequest>(_withFirebaseWriteRequest);
    on<FirebaseUpdateRequest>(_withFirebaseUpdateRequest);
    on<FirebaseDeleteRequest>(_withFirebaseDeleteRequest);

    on<FirebaseWatchIdRequest>(_withFirebaseWatchIdRequest);
    on<FirebaseWatchAllRequest>(_withFirebaseWatchAllRequest);
  }

  void _withFirebaseReadIdRequest(
    FirebaseReadIdRequest request,
    ResponseSender send,
  ) async {
    final content = await _client.read(path: request.path, id: request.id);
    if (content.isEmpty) {
      send(Left(NoContentFirebaseFailureResponse()));
    } else {
      send(Right(FirebaseSuccessResponse(content)));
    }
  }

  void _withFirebaseReadAllRequest(
    FirebaseReadAllRequest request,
    ResponseSender send,
  ) async {
    final content = await _client.readAll(path: request.path);
    if (content.isEmpty) {
      send(Left(NoContentFirebaseFailureResponse()));
    } else {
      send(Right(FirebaseSuccessResponse(content)));
    }
  }

  void _withFirebaseWriteRequest(
    FirebaseWriteRequest request,
    ResponseSender send,
  ) async {
    final id = await _client.write(
      path: request.path,
      id: request.id,
      content: request.toJson(),
    );
    if (id.isEmpty) {
      send(Left(NoContentFirebaseFailureResponse()));
    } else {
      send(Right(FirebaseSuccessResponse({'id': id})));
    }
  }

  void _withFirebaseUpdateRequest(
    FirebaseUpdateRequest request,
    ResponseSender send,
  ) async {
    await _client.update(
      path: request.path,
      id: request.id,
      content: request.toJson(),
    );
    send(Right(FirebaseSuccessResponse({})));
  }

  void _withFirebaseDeleteRequest(
    FirebaseDeleteRequest request,
    ResponseSender send,
  ) async {
    await _client.delete(path: request.path, id: request.id);
    send(Right(FirebaseSuccessResponse({})));
  }

  void _withFirebaseWatchIdRequest(
    FirebaseWatchIdRequest request,
    ResponseSender send,
  ) {
    final featureStream = _client.watch(path: request.path, id: request.id);
    featureStream.listen(
      (model) => send(Right(FirebaseSuccessResponse(model))),
    );
  }

  void _withFirebaseWatchAllRequest(
    FirebaseWatchAllRequest request,
    ResponseSender send,
  ) {
    final featureStream = _client.watchAll(path: request.path);
    featureStream.listen(
      (model) => send(Right(FirebaseSuccessResponse(model))),
    );
  }
}
