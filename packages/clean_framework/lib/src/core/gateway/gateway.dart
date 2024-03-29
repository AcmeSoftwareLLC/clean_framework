import 'dart:async';

import 'package:clean_framework/src/core/external_interface/request.dart';
import 'package:clean_framework/src/core/external_interface/response.dart';
import 'package:clean_framework/src/core/use_case/provider/use_case_provider.dart';
import 'package:clean_framework/src/core/use_case/use_case.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class Gateway<O extends Output, R extends Request,
    P extends SuccessResponse, S extends SuccessInput> {
  void attach(
    ProviderRef<Object> ref, {
    required List<UseCaseProviderBase> providers,
    List<UseCaseProviderFamilyBase> families = const [],
  }) {
    for (final useCaseProvider in providers) {
      useCaseProvider.notifier.listen(
        (notifier) => _subscribe(ref, notifier),
      );
    }
    for (final useCaseProviderFamily in families) {
      useCaseProviderFamily.notifier.listen(
        (notifier) => _subscribe(ref, notifier.$1),
      );
    }
  }

  final Set<UseCase> _useCases = {};

  void _subscribe(ProviderRef<Object> ref, Refreshable<UseCase> notifier) {
    final useCase = ref.read(notifier);
    _useCases.add(useCase);
    useCase.subscribe<O, S>(buildInput);
  }

  @visibleForTesting
  @nonVirtual
  // ignore: use_setters_to_change_properties
  void feedResponse(Responder<R, P> feeder, {Type? source}) {
    assert(
      _source == null,
      '\n\nThe "$runtimeType" is already attached to ${_source!.type}.\n',
    );

    _source = _Source(feeder, source);
  }

  @visibleForTesting
  @nonVirtual
  Future<Either<FailureInput, S>> buildInput(O output) {
    return _processRequest(buildRequest(output));
  }

  _Source<R, P>? _source;

  S onSuccess(covariant P response);

  FailureInput onFailure(covariant FailureResponse failureResponse);

  R buildRequest(O output);

  Future<Either<FailureInput, S>> _processRequest(R request) async {
    final either = await _source!.responder(request);
    return either.fold(
      (failureResponse) => Either.left(onFailure(failureResponse)),
      (response) => Either.right(onSuccess(response)),
    );
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
    for (final useCase in _useCases) {
      useCase.setInput(onSuccess(response));
    }
  }
}

typedef Responder<R extends Request, P extends SuccessResponse>
    = FutureOr<Either<FailureResponse, P>> Function(R request);

class _Source<R extends Request, P extends SuccessResponse> {
  _Source(this.responder, this.type);

  final Responder<R, P> responder;
  final Type? type;
}
