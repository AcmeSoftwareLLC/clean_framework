import 'dart:async';

import 'package:either_dart/either.dart';

import 'gateway.dart';

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

  void on<E extends R>(
    RequestHandler<E, S> handler,
  ) {
    _requestController.stream.where((e) => e.request is E).listen(
      (e) async {
        final request = e.request as E;

        if (e is _StreamRequestCompleter) {
          final event = e as _StreamRequestCompleter<R, S>;
          handler(request, (result) {
            result.fold(
              (failure) => event.complete(Left(failure)),
              (success) {
                if (!event.isCompleted) event.complete(Right(success));
                event.emitSuccess(success);
              },
            );
          });
        } else {
          await handler(request, e.complete);
        }
      },
    );
  }
}

typedef GatewayConnection<G extends Gateway> = G Function();

typedef ResponseSender<S extends SuccessResponse> = void Function(
  Either<FailureResponse, S> response,
);

typedef RequestHandler<E extends Request, S extends SuccessResponse>
    = FutureOr<void> Function(E request, ResponseSender<S> send);

class _RequestCompleter<R extends Request, S extends SuccessResponse> {
  _RequestCompleter(this.request) : _completer = Completer();

  final R request;
  final Completer<Either<FailureResponse, S>> _completer;

  Future<Either<FailureResponse, S>> get future => _completer.future;

  bool get isCompleted => _completer.isCompleted;

  void complete(Either<FailureResponse, S> value) => _completer.complete(value);
}

class _StreamRequestCompleter<R extends Request, S extends SuccessResponse>
    extends _RequestCompleter<R, S> {
  _StreamRequestCompleter(R request, this.emitSuccess) : super(request);

  final void Function(S) emitSuccess;
}
