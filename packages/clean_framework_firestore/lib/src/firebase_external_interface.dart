import 'package:clean_framework/clean_framework_legacy.dart';

import 'package:clean_framework_firestore/src/firebase_client.dart';
import 'package:clean_framework_firestore/src/firebase_requests.dart';
import 'package:clean_framework_firestore/src/firebase_responses.dart';

class FirebaseExternalInterface
    extends ExternalInterface<FirebaseRequest, FirebaseSuccessResponse> {
  FirebaseExternalInterface({
    required List<GatewayConnection<Gateway>> gatewayConnections,
    FirebaseClient? firebaseClient,
  })  : _client = firebaseClient ?? FirebaseClient(),
        super(gatewayConnections);
  final FirebaseClient _client;

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

  @override
  FailureResponse onError(Object error) {
    if (error is FirebaseFailureResponse) return error;
    return UnknownFailureResponse(error);
  }

  Future<void> _withFirebaseReadIdRequest(
    FirebaseReadIdRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final content = await _client.read(path: request.path, id: request.id);
    if (content.isEmpty) {
      sendError(
        const FirebaseFailureResponse(type: FirebaseFailureType.noContent),
      );
    } else {
      send(FirebaseSuccessResponse(content));
    }
  }

  Future<void> _withFirebaseReadAllRequest(
    FirebaseReadAllRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final content = await _client.readAll(path: request.path);
    if (content.isEmpty) {
      sendError(
        const FirebaseFailureResponse(type: FirebaseFailureType.noContent),
      );
    } else {
      send(FirebaseSuccessResponse(content));
    }
  }

  Future<void> _withFirebaseWriteRequest(
    FirebaseWriteRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final id = await _client.write(
      path: request.path,
      id: request.id,
      content: request.toJson(),
      merge: request.merge,
    );
    if (id.isEmpty) {
      sendError(
        const FirebaseFailureResponse(type: FirebaseFailureType.noContent),
      );
    } else {
      send(FirebaseSuccessResponse({'id': id}));
    }
  }

  Future<void> _withFirebaseUpdateRequest(
    FirebaseUpdateRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    await _client.update(
      path: request.path,
      id: request.id,
      content: request.toJson(),
    );
    send(const FirebaseSuccessResponse({}));
  }

  Future<void> _withFirebaseDeleteRequest(
    FirebaseDeleteRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    await _client.delete(path: request.path, id: request.id);
    send(const FirebaseSuccessResponse({}));
  }

  void _withFirebaseWatchIdRequest(
    FirebaseWatchIdRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) {
    _client.watch(path: request.path, id: request.id).listen(
          (model) => send(FirebaseSuccessResponse(model)),
        );
  }

  void _withFirebaseWatchAllRequest(
    FirebaseWatchAllRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) {
    _client.watchAll(path: request.path).listen(
          (model) => send(FirebaseSuccessResponse(model)),
        );
  }
}
