import 'dart:async';

import 'package:clean_framework/src/core/use_case/helpers/use_case_input.dart';
import 'package:clean_framework/src/core/use_case/use_case_debounce_mixin.dart';
import 'package:clean_framework/src/core/use_case/use_case_helpers.dart';
import 'package:clean_framework/src/core/use_case/use_case_state.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

export 'helpers/use_case_input.dart';
export 'use_case_helpers.dart';

typedef InputCallback<UCS extends UseCaseState, I extends DomainInput> = UCS
    Function(I);

abstract class UseCase<UCS extends UseCaseState> extends StateNotifier<UCS>
    with UseCaseDebounceMixin {
  UseCase({
    required UCS useCaseState,
    List<UseCaseTransformer<UCS>> transformers = const [],
  }) : super(useCaseState) {
    if (transformers.isNotEmpty) {
      _outputFilters.addTransformers(transformers);
      _inputFilters.addTransformers(transformers);
    }
  }

  final OutputFilterMap<UCS> _outputFilters = {};
  final InputFilterMap<UCS> _inputFilters = {};
  final RequestSubscriptionMap _requestSubscriptions = {};

  @protected
  @useResult

  /// The current domain state instance of this [UseCase].
  ///
  /// Updating this variable will synchronously call all the listeners.
  /// Notifying the listeners is O(N) with N the number of listeners.
  ///
  /// Updating the domain state will throw if at least one listener throws.
  ///
  /// For testing purposes, you can use [debugUseCaseState] to access the domain state.
  UCS get useCaseState => super.state;

  @protected

  /// Updates the [useCaseState] with the [newUseCaseState] and notifies all the listeners.
  ///
  /// For testing purposes, you can use [debugUseCaseStateUpdate] to update use case state.
  set useCaseState(UCS newUseCaseState) => super.state = newUseCaseState;

  /// A development-only way to access [useCaseState] outside of [UseCase].
  ///
  /// The only difference with [useCaseState] is that [debugUseCaseState] is not "protected".\
  /// Will not work in release mode.
  ///
  /// This is useful for tests.
  UCS get debugUseCaseState => super.state;

  @visibleForTesting

  /// A development-only way to update [useCaseState] outside of [UseCase].
  UCS debugUseCaseStateUpdate(UCS Function(UCS) update) {
    late UCS updatedUseCaseState;
    assert(
      () {
        updatedUseCaseState = useCaseState = update(super.state);
        return true;
      }(),
      '',
    );
    return updatedUseCaseState;
  }

  O getOutput<O extends DomainOutput>() => transformToOutput(useCaseState);

  @visibleForTesting
  O transformToOutput<O extends DomainOutput>(UCS entity) =>
      _outputFilters<O>(entity);

  void setInput<I extends DomainInput>(I input) {
    useCaseState = _inputFilters<I>(useCaseState, input);
  }

  void subscribe<O extends DomainOutput, I extends DomainInput>(
    RequestSubscription<O, I> subscription,
  ) {
    _requestSubscriptions.add<O>(subscription);
  }

  @visibleForTesting
  @protected
  FutureOr<Either<FailureDomainInput, S>>
      getInternalInput<S extends SuccessDomainInput>(
    DomainOutput output,
  ) {
    return _requestSubscriptions.getDomainInput<S>(output);
  }

  @visibleForTesting
  @protected
  Future<void> request<S extends SuccessDomainInput>(
    DomainOutput output, {
    required InputCallback<UCS, S> onSuccess,
    required InputCallback<UCS, FailureDomainInput> onFailure,
  }) async {
    final input = await getInternalInput<S>(output);

    useCaseState = input.fold(
      (failure) {
        CleanFrameworkObserver.instance.onFailureInput(this, output, failure);
        return onFailure(failure);
      },
      (success) {
        CleanFrameworkObserver.instance.onSuccessInput(this, output, success);
        return onSuccess(success);
      },
    );
  }

  @visibleForTesting
  @protected
  Future<UseCaseInput<S>> getInput<S extends SuccessDomainInput>(
    DomainOutput output,
  ) async {
    final input = await getInternalInput<S>(output);

    return input.fold(
      (failure) {
        CleanFrameworkObserver.instance.onFailureInput(this, output, failure);
        return FailureUseCaseInput(failure);
      },
      (success) {
        CleanFrameworkObserver.instance.onSuccessInput(this, output, success);
        return SuccessUseCaseInput(success);
      },
    );
  }

  @override
  @mustCallSuper
  void dispose() {
    clearDebounce();
    super.dispose();
  }

  @override
  bool updateShouldNotify(UCS old, UCS current) {
    return !_isSilentUpdate && super.updateShouldNotify(old, current);
  }

  bool _isSilentUpdate = false;

  @protected
  @visibleForTesting

  /// The [useCaseState] updates within the [updater] will not be notified to the
  /// [UseCase] listeners, but will silently update it.
  Future<void> withSilencedUpdate(FutureOr<void> Function() updater) async {
    assert(
      !_isSilentUpdate,
      '\n\nConcurrently running with more than one "withSilencedUpdate" '
      'modifier is not supported.\n',
    );

    _isSilentUpdate = true;
    await updater();
    _isSilentUpdate = false;
  }
}
