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

  @visibleForTesting
  @protected
  E get entity => super.state;

  @visibleForTesting
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
}
