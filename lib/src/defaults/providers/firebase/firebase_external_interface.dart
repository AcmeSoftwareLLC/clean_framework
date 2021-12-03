import 'package:clean_framework/clean_framework_providers.dart';

import 'firebase_client.dart';
import 'firebase_requests.dart';
import 'firebase_responses.dart';

class FirebaseExternalInterface
    extends ExternalInterface<FirebaseRequest, FirebaseSuccessResponse> {
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

  @override
  FailureResponse onError(Object error) {
    if (error is FirebaseFailureResponse) return error;
    return UnknownFailureResponse(error);
  }

  void _withFirebaseReadIdRequest(
    FirebaseReadIdRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final content = await _client.read(path: request.path, id: request.id);
    if (content.isEmpty) {
      sendError(FirebaseFailureResponse(type: FirebaseFailureType.noContent));
    } else {
      send(FirebaseSuccessResponse(content));
    }
  }

  void _withFirebaseReadAllRequest(
    FirebaseReadAllRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final content = await _client.readAll(path: request.path);
    if (content.isEmpty) {
      sendError(FirebaseFailureResponse(type: FirebaseFailureType.noContent));
    } else {
      send(FirebaseSuccessResponse(content));
    }
  }

  void _withFirebaseWriteRequest(
    FirebaseWriteRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    final id = await _client.write(
      path: request.path,
      id: request.id,
      content: request.toJson(),
    );
    if (id.isEmpty) {
      sendError(FirebaseFailureResponse(type: FirebaseFailureType.noContent));
    } else {
      send(FirebaseSuccessResponse({'id': id}));
    }
  }

  void _withFirebaseUpdateRequest(
    FirebaseUpdateRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    await _client.update(
      path: request.path,
      id: request.id,
      content: request.toJson(),
    );
    send(FirebaseSuccessResponse({}));
  }

  void _withFirebaseDeleteRequest(
    FirebaseDeleteRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) async {
    await _client.delete(path: request.path, id: request.id);
    send(FirebaseSuccessResponse({}));
  }

  void _withFirebaseWatchIdRequest(
    FirebaseWatchIdRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) {
    final featureStream = _client.watch(path: request.path, id: request.id);
    featureStream.listen(
      (model) => send(FirebaseSuccessResponse(model)),
    );
  }

  void _withFirebaseWatchAllRequest(
    FirebaseWatchAllRequest request,
    ResponseSender<FirebaseSuccessResponse> send,
  ) {
    final featureStream = _client.watchAll(path: request.path);
    featureStream.listen(
      (model) => send(FirebaseSuccessResponse(model)),
    );
  }
}
