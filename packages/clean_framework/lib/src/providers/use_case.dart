import 'dart:async';

import 'package:clean_framework/src/providers/entity.dart';
import 'package:clean_framework/src/providers/use_case/use_case_helpers.dart';
import 'package:clean_framework/src/providers/use_case_debounce_mixin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

export 'package:clean_framework/src/providers/use_case/use_case_helpers.dart';

typedef InputCallback<E extends Entity, I extends Input> = E Function(I);

abstract class UseCase<E extends Entity> extends StateNotifier<E>
    with UseCaseDebounceMixin {
  UseCase({
    required E entity,
    @Deprecated('Use filters instead') OutputFilterMap<E>? outputFilters,
    @Deprecated('Use filters instead') InputFilterMap<E>? inputFilters,
    List<UseCaseFilter<E>>? filters,
  })  : _outputFilters = Map.of(outputFilters ?? const {}),
        _inputFilters = Map.of(inputFilters ?? const {}),
        super(entity) {
    if (filters != null && filters.isNotEmpty) {
      _outputFilters.addFilters(filters);
      _inputFilters.addFilters(filters);
    }
  }

  final OutputFilterMap<E> _outputFilters;
  final InputFilterMap<E> _inputFilters;
  final RequestSubscriptionMap _requestSubscriptions = {};

  @visibleForTesting
  @protected
  E get entity => super.state;

  @protected
  set entity(E newEntity) => super.state = newEntity;

  O getOutput<O extends Output>() => _outputFilters<O>(entity);

  void setInput<I extends Input>(I input) {
    entity = _inputFilters<I>(entity, input);
  }

  void subscribe<O extends Output, I extends Input>(
    RequestSubscription<I> subscription,
  ) {
    _requestSubscriptions.add<O>(subscription);
  }

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
}
