import 'dart:async';

import 'package:clean_framework/src/core/dependency/dependency_provider.dart';
import 'package:clean_framework/src/core/external_interface/request.dart';
import 'package:clean_framework/src/core/external_interface/response.dart';
import 'package:clean_framework/src/core/gateway/gateway.dart';
import 'package:clean_framework/src/core/gateway/gateway_provider.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

part 'external_interface_delegate.dart';

abstract class ExternalInterface<R extends Request, S extends SuccessResponse> {
  DependencyRef? _ref;

  @internal
  void attach(
    ProviderRef<Object> ref, {
    required List<GatewayProvider> providers,
  }) {
    _ref = DependencyRef(ref);
    handleRequest();

    for (final gatewayProvider in providers) {
      _initTransporter(ref.read(gatewayProvider()));
    }
  }

  /// Locates dependency from the [provider].
  @protected
  @nonVirtual
  T locate<T extends Object>(DependencyProvider<T> provider) {
    assert(_ref != null, '$runtimeType has not been attached!');
    return _ref!.read(provider);
  }

  void _initTransporter(Gateway gateway) {
    // ignore: invalid_use_of_visible_for_testing_member
    gateway.feedResponse(
      (request) async {
        final req = request as R;

        if (gateway is WatcherGateway) {
          final requestCompleter = _StreamRequestCompleter<R, S>(
            req,
            gateway.yieldResponse,
          );

          _requestController.add(requestCompleter);
          return requestCompleter.future;
        } else {
          return this.request(req);
        }
      },
      source: runtimeType,
    );
  }

  final _RequestController<R, S> _requestController =
      StreamController.broadcast();

  @visibleForTesting
  Future<Either<FailureResponse, S>> request(R request) {
    final requestCompleter = RequestCompleter<R, S>(request);

    _requestController.add(requestCompleter);
    return requestCompleter.future;
  }

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
            final handlerCall = handler(
              request,
              (response) {
                if (!event.isCompleted) event.complete(response);
                event.emitSuccess(response);
              },
            );

            if (handlerCall is Future) {
              unawaited(
                handlerCall.catchError(
                  (Object error, StackTrace stackTrace) {
                    e.completeFailure(
                      _onError(error, request, stackTrace),
                    );
                  },
                ),
              );
            }
          } else {
            await handler(request, e.complete);
          }
        } catch (error, stackTrace) {
          e.completeFailure(_onError(error, request, stackTrace));
        }
      },
    );
  }

  Never sendError(Object error) => throw error;

  FailureResponse _onError(Object error, R request, StackTrace stackTrace) {
    CleanFrameworkObserver.instance.onExternalError(
      this,
      request,
      error,
      stackTrace,
    );
    final failure = onError(error);
    CleanFrameworkObserver.instance.onFailureResponse(this, request, failure);
    return failure;
  }
}

typedef _RequestController<R extends Request, S extends SuccessResponse>
    = StreamController<RequestCompleter<R, S>>;

typedef ResponseSender<S extends SuccessResponse> = void Function(S response);

typedef RequestHandler<E extends Request, S extends SuccessResponse>
    = FutureOr<void> Function(E request, ResponseSender<S> send);

class RequestCompleter<R extends Request, S extends SuccessResponse> {
  RequestCompleter(this.request) : _completer = Completer();

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
    extends RequestCompleter<R, S> {
  _StreamRequestCompleter(super.request, this.emitSuccess);

  final void Function(S) emitSuccess;
}
