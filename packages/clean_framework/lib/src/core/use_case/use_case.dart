import 'dart:async';

import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:clean_framework/src/core/use_case/use_case_debounce_mixin.dart';
import 'package:clean_framework/src/core/use_case/use_case_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

export 'package:clean_framework/src/core/use_case/use_case_helpers.dart';

typedef InputCallback<E extends Entity, I extends Input> = E Function(I);

abstract class UseCase<E extends Entity> extends StateNotifier<E>
    with UseCaseDebounceMixin {
  UseCase({
    required E entity,
    List<UseCaseTransformer<E>>? transformers,
    @Deprecated('Use transformers instead') OutputFilterMap<E>? outputFilters,
    @Deprecated('Use transformers instead') InputFilterMap<E>? inputFilters,
  })  : _outputFilters = Map.of(outputFilters ?? const {}),
        _inputFilters = Map.of(inputFilters ?? const {}),
        super(entity) {
    if (transformers != null && transformers.isNotEmpty) {
      _outputFilters.addTransformers(transformers);
      _inputFilters.addTransformers(transformers);
    }
  }

  final OutputFilterMap<E> _outputFilters;
  final InputFilterMap<E> _inputFilters;
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
  E get debugEntity => super.debugState;

  @visibleForTesting

  /// A development-only way to update [entity] outside of [UseCase].
  E debugEntityUpdate(E Function(E) update) {
    late E updatedEntity;
    assert(
      () {
        updatedEntity = entity = update(super.debugState);
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
    RequestSubscription<I> subscription,
  ) {
    _requestSubscriptions.add<O>(subscription);
  }

  @visibleForTesting
  @protected
  Future<void> request<O extends Output, S extends SuccessInput>(
    O output, {
    required InputCallback<E, S> onSuccess,
    required InputCallback<E, FailureInput> onFailure,
  }) async {
    final input = await _requestSubscriptions<O, S>(output);

    entity = input.fold(onFailure, onSuccess);
  }

  @override
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
