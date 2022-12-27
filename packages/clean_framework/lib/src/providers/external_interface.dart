import 'dart:async';

import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';

abstract class ExternalInterface<R extends Request, S extends SuccessResponse> {
  ExternalInterface(List<GatewayConnection<Gateway>> gatewayConnections) {
    handleRequest();
    for (final connection in gatewayConnections) {
      final gateway = connection();
      gateway.transport = (request) async {
        final req = request as R;
        final requestCompleter = gateway is WatcherGateway
            ? _StreamRequestCompleter<R, S>(req, gateway.yieldResponse)
            : _RequestCompleter<R, S>(req);

        _requestController.add(requestCompleter);
        return requestCompleter.future;
      };
    }
  }

  final StreamController<_RequestCompleter<R, S>> _requestController =
      StreamController.broadcast();

  void handleRequest();

  FailureResponse onError(Object error);

  void on<E extends R>(
    RequestHandler<E, S> handler,
  ) {
    _requestController.stream.where((e) => e.request is E).listen(
      (e) async {
        final request = e.request as E;

        try {
          if (e is _StreamRequestCompleter) {
            final event = e as _StreamRequestCompleter<R, S>;

            final handlerCall = handler(request, (response) {
              if (!event.isCompleted) event.complete(response);
              event.emitSuccess(response);
            });
            if (handlerCall is Future) {
              unawaited(
                handlerCall.catchError(
                  (Object error) => e.completeFailure(_onError(error, request)),
                ),
              );
            }
          } else {
            await handler(request, e.complete);
          }
        } catch (error) {
          e.completeFailure(_onError(error, request));
        }
      },
    );
  }

  Never sendError(Object error) => throw error;

  FailureResponse _onError(Object error, R request) {
    CleanFrameworkObserver.instance.onExternalError(this, request, error);
    final failure = onError(error);
    CleanFrameworkObserver.instance.onFailureResponse(this, request, failure);
    return failure;
  }
}

typedef GatewayConnection<G extends Gateway> = G Function();

typedef ResponseSender<S extends SuccessResponse> = void Function(S response);

typedef RequestHandler<E extends Request, S extends SuccessResponse>
    = FutureOr<void> Function(E request, ResponseSender<S> send);

class _RequestCompleter<R extends Request, S extends SuccessResponse> {
  _RequestCompleter(this.request) : _completer = Completer();

  final R request;
  final Completer<Either<FailureResponse, S>> _completer;

  Future<Either<FailureResponse, S>> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void complete(S success) => _completer.complete(Either.right(success));

  void completeFailure(FailureResponse failure) {
    _completer.complete(Either.left(failure));
  }
}

class _StreamRequestCompleter<R extends Request, S extends SuccessResponse>
    extends _RequestCompleter<R, S> {
  _StreamRequestCompleter(super.request, this.emitSuccess);

  final void Function(S) emitSuccess;
}
