import 'dart:async';

import 'package:clean_framework/src/core/external_interface/request.dart';
import 'package:clean_framework/src/core/external_interface/response.dart';
import 'package:clean_framework/src/core/use_case/use_case.dart';
import 'package:clean_framework/src/core/use_case/use_case_provider.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class Gateway<O extends Output, R extends Request,
    P extends SuccessResponse, S extends SuccessInput> {
  void attach(
    ProviderRef<Object> ref, {
    required List<UseCaseProvider> providers,
  }) {
    _ref = ref;
    _useCaseProviders = providers;

    for (final useCaseProvider in providers) {
      useCaseProvider.notifier.then(
        (notifier) {
          ref
              .read(notifier)
              .subscribe<O, S>((output) => buildInput(output as O));
        },
      );
    }
  }

  late final ProviderRef<Object> _ref;
  late final List<UseCaseProvider> _useCaseProviders;

  @visibleForTesting
  @nonVirtual
  // ignore: use_setters_to_change_properties
  void feedResponse(Responder<R, P> feeder) => _responder = feeder;

  @visibleForTesting
  @nonVirtual
  Future<Either<FailureInput, S>> buildInput(O output) {
    return _processRequest(buildRequest(output));
  }

  late final Responder<R, P> _responder;

  S onSuccess(covariant P response);
  FailureInput onFailure(covariant FailureResponse failureResponse);
  R buildRequest(O output);

  Future<Either<FailureInput, S>> _processRequest(R request) async {
    final either = await _responder(request);
    return either.fold(
      (failureResponse) => Either.left(_onFailure(failureResponse)),
      (response) => Either.right(onSuccess(response)),
    );
  }

  FailureInput _onFailure(FailureResponse failureResponse) {
    final failureInput = onFailure(failureResponse);
    CleanFrameworkObserver.instance.onFailureInput(failureInput);
    return failureInput;
  }
}

abstract class WatcherGateway<
    O extends Output,
    R extends Request,
    P extends SuccessResponse,
    S extends SuccessInput> extends Gateway<O, R, P, S> {
  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @nonVirtual
  void yieldResponse(P response) {
    for (final useCaseProvider in _useCaseProviders) {
      useCaseProvider.notifier.then(
        (notifier) {
          _ref.read(notifier).setInput(onSuccess(response));
        },
      );
    }
  }
}

typedef Responder<R extends Request, P extends SuccessResponse>
    = FutureOr<Either<FailureResponse, P>> Function(R request);
