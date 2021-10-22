import 'package:clean_framework/clean_framework_providers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:either_dart/either.dart';

import 'entity.dart';

abstract class UseCase<E extends Entity> extends StateNotifier<E> {
  // TODO Replace with a proper implementation like Freezed
  final Map<Type, dynamic> _outputFilters;
  final Map<Type, Function> _inputFilters;

  final Map<Type, Function> _requestSubscriptions = {};

  UseCase({
    required E entity,
    Map<Type, dynamic>? outputFilters,
    Map<Type, Function>? inputFilters,
  })  : _outputFilters = outputFilters ?? const {},
        _inputFilters = inputFilters ?? const {},
        super(entity);

  @override
  void dispose() {
    super.dispose();
  }

  @visibleForTesting
  @protected
  E get entity => super.state;

  @protected
  set entity(newEntity) => super.state = newEntity;

  O getOutput<O extends Output>() {
    final filter = _outputFilters[O];
    if (filter == null) {
      throw StateError('Output filter not defined for $O');
    }
    return filter(entity);
  }

  void setInput<I extends Input>(I input) {
    if (_inputFilters[I] == null) {
      throw StateError('Input processor not defined for $I');
    }
    final processor = _inputFilters[I] as InputProcessor<I, E>;
    entity = processor(input, entity);
  }

  void subscribe(Type outputType, Function callback) {
    if (_requestSubscriptions[outputType] != null) {
      throw StateError('A subscription for $outputType already exists');
    }
    _requestSubscriptions[outputType] = callback;
  }

  Future<void> request<O extends Output, S extends SuccessInput>(
    O output, {
    required E Function(S successInput) onSuccess,
    required E Function(FailureInput failureInput) onFailure,
  }) async {
    final callback = _requestSubscriptions[O] ??
        (_) => Left<NoSubscriptionFailureInput, S>(
              NoSubscriptionFailureInput(O),
            );
    final Either<FailureInput, S> either = await callback(output);
    entity = either.fold(onFailure, onSuccess);
  }
}

typedef InputCallback = void Function<I extends Input>(I input);

typedef InputProcessor<I extends Input, E extends Entity> = E Function(
  I input,
  E entity,
);

typedef SubscriptionFilter<E extends Entity, V extends ViewModel> = V Function(
  E entity,
);

@immutable
abstract class Output extends Equatable {
  @override
  bool get stringify => true;
}

@immutable
abstract class Input {}

class SuccessInput extends Input {}

class FailureInput extends Input {
  final String message;

  FailureInput({this.message = ''});
}

class NoSubscriptionFailureInput extends FailureInput {
  NoSubscriptionFailureInput(Type t)
      : super(message: 'No subscription exists for this request of $t');
}
