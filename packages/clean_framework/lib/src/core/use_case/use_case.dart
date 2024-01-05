import 'dart:async';

import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:clean_framework/src/core/use_case/helpers/use_case_input.dart';
import 'package:clean_framework/src/core/use_case/use_case_debounce_mixin.dart';
import 'package:clean_framework/src/core/use_case/use_case_helpers.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

export 'helpers/use_case_input.dart';
export 'use_case_helpers.dart';

typedef InputCallback<E extends Entity, I extends Input> = E Function(I);

abstract class UseCase<E extends Entity> extends StateNotifier<E>
    with UseCaseDebounceMixin {
  UseCase({
    required E entity,
    List<UseCaseTransformer<E>> transformers = const [],
  }) : super(entity) {
    if (transformers.isNotEmpty) {
      _outputFilters.addTransformers(transformers);
      _inputFilters.addTransformers(transformers);
    }
  }

  final OutputFilterMap<E> _outputFilters = {};
  final InputFilterMap<E> _inputFilters = {};
  final RequestSubscriptionMap _requestSubscriptions = {};

  @protected
  @useResult

  /// The current entity instance of this [UseCase].
  ///
  /// Updating this variable will synchronously call all the listeners.
  /// Notifying the listeners is O(N) with N the number of listeners.
  ///
  /// Updating the entity will throw if at least one listener throws.
  ///
  /// For testing purposes, you can use [debugEntity] to access the entity.
  E get entity => super.state;

  @protected

  /// Updates the [entity] with the [newEntity] and notifies all the listeners.
  ///
  /// For testing purposes, you can use [debugEntityUpdate] to update entity.
  set entity(E newEntity) => super.state = newEntity;

  /// A development-only way to access [entity] outside of [UseCase].
  ///
  /// The only difference with [entity] is that [debugEntity] is not "protected".\
  /// Will not work in release mode.
  ///
  /// This is useful for tests.
  E get debugEntity => super.state;

  @visibleForTesting

  /// A development-only way to update [entity] outside of [UseCase].
  E debugEntityUpdate(E Function(E) update) {
    late E updatedEntity;
    assert(
      () {
        updatedEntity = entity = update(super.state);
        return true;
      }(),
      '',
    );
    return updatedEntity;
  }

  O getOutput<O extends Output>() => transformToOutput(entity);

  @visibleForTesting
  O transformToOutput<O extends Output>(E entity) => _outputFilters<O>(entity);

  void setInput<I extends Input>(I input) {
    entity = _inputFilters<I>(entity, input);
  }

  void subscribe<O extends Output, I extends Input>(
    RequestSubscription<O, I> subscription,
  ) {
    _requestSubscriptions.add<O>(subscription);
  }

  @visibleForTesting
  @protected
  FutureOr<Either<FailureInput, S>> getInternalInput<S extends SuccessInput>(
    Output output,
  ) {
    return _requestSubscriptions.getInput<S>(output);
  }

  @visibleForTesting
  @protected
  Future<void> request<S extends SuccessInput>(
    Output output, {
    required InputCallback<E, S> onSuccess,
    required InputCallback<E, FailureInput> onFailure,
  }) async {
    final input = await getInternalInput<S>(output);

    entity = input.fold(
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
  Future<UseCaseInput<S>> getInput<S extends SuccessInput>(
    Output output,
  ) async {
    final input = await getInternalInput<S>(output);

    return input.fold(
      (failure) {
        CleanFrameworkObserver.instance.onFailureInput(this, output, failure);
        return Failure(failure);
      },
      (success) {
        CleanFrameworkObserver.instance.onSuccessInput(this, output, success);
        return Success(success);
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
  bool updateShouldNotify(E old, E current) {
    return !_isSilentUpdate && super.updateShouldNotify(old, current);
  }

  bool _isSilentUpdate = false;

  @protected
  @visibleForTesting

  /// The [entity] updates within the [updater] will not be notified to the
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
