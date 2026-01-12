import 'dart:async';

import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:clean_framework/src/core/use_case/helpers/use_case_input.dart';
import 'package:clean_framework/src/core/use_case/use_case_debounce_mixin.dart';
import 'package:clean_framework/src/core/use_case/use_case_helpers.dart';
import 'package:clean_framework/src/utilities/clean_framework_observer.dart';
import 'package:clean_framework/src/utilities/either.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meta/meta.dart';

export 'helpers/use_case_input.dart';
export 'use_case_helpers.dart';

typedef InputCallback<E extends Entity, I extends DomainInput> = E Function(I);

abstract class UseCase<E extends Entity> extends StateNotifier<E> with UseCaseDebounceMixin {
  UseCase({
    required E entity,
    List<UseCaseTransformer<E>> transformers = const [],
  }) : super(entity) {
    if (transformers.isNotEmpty) {
      _domainModelFilters.addTransformers(transformers);
      _domainInputFilters.addTransformers(transformers);
    }
  }

  final DomainModelFilterMap<E> _domainModelFilters = {};
  final DomainInputFilterMap<E> _domainInputFilters = {};
  final RequestSubscriptionMap _requestSubscriptions = {};

  @protected
  @useResult

  /// The current entity instance of this [UseCase].
  ///
  /// Updating this variable will synchronously call all the listeners.
  /// Notifying the listeners is O(N) with N the number of listeners.
  ///
  /// Updating the domain state will throw if at least one listener throws.
  E get entity => super.state;

  @protected

  /// Updates the [entity] with the [newEntity] and notifies all the listeners.
  ///
  /// For testing purposes,
  /// you can use [debugEntityUpdate] to update use case state.
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

  M getDomainModel<M extends DomainModel>() => transformToDomainModel(entity);

  @visibleForTesting
  M transformToDomainModel<M extends DomainModel>(E entity) => _domainModelFilters<M>(entity);

  void setInput<I extends DomainInput>(I input) {
    entity = _domainInputFilters<I>(entity, input);
  }

  void subscribe<M extends DomainModel, I extends DomainInput>(
    RequestSubscription<M, I> subscription,
  ) {
    _requestSubscriptions.add<M>(subscription);
  }

  @visibleForTesting
  @protected
  FutureOr<Either<FailureDomainInput, S>> getInternalInput<S extends SuccessDomainInput>(
    DomainModel domainModel,
  ) {
    return _requestSubscriptions.getDomainInput<S>(domainModel);
  }

  @visibleForTesting
  @protected
  Future<void> request<S extends SuccessDomainInput>(
    DomainModel domainModel, {
    required InputCallback<E, S> onSuccess,
    required InputCallback<E, FailureDomainInput> onFailure,
  }) async {
    final input = await getInternalInput<S>(domainModel);

    entity = input.fold(
      (failure) {
        CleanFrameworkObserver.instance.onFailureInput(this, domainModel, failure);
        return onFailure(failure);
      },
      (success) {
        CleanFrameworkObserver.instance.onSuccessInput(this, domainModel, success);
        return onSuccess(success);
      },
    );
  }

  @visibleForTesting
  @protected
  Future<UseCaseInput<S>> getInput<S extends SuccessDomainInput>(
    DomainModel domainModel,
  ) async {
    final input = await getInternalInput<S>(domainModel);

    return input.fold(
      (failure) {
        CleanFrameworkObserver.instance.onFailureInput(this, domainModel, failure);
        return FailureUseCaseInput(failure);
      },
      (success) {
        CleanFrameworkObserver.instance.onSuccessInput(this, domainModel, success);
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
