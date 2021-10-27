import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:state_notifier/state_notifier.dart';

class UseCaseFake extends Fake implements UseCase<EntityFake> {
  EntityFake _entity = EntityFake();
  late Function subscription;
  final Output? output;

  UseCaseFake({this.output});

  @override
  EntityFake get entity => _entity;

  @override
  set entity(newEntity) => _entity = newEntity;

  @override
  RemoveListener addListener(Listener<EntityFake> listener,
      {bool fireImmediately = true}) {
    return () {};
  }

  @override
  EntityFake get debugState => _entity;

  @override
  void dispose() {}

  @override
  bool get hasListeners => true;

  @override
  bool get mounted => true;

  @override
  Future<void> request<O extends Output, S extends SuccessInput>(O output,
      {required EntityFake Function(S successInput) onSuccess,
      required EntityFake Function(FailureInput failureInput)
          onFailure}) async {
    final Either<FailureInput, S> either = await subscription.call(output);
    _entity = either.fold(
        (FailureInput failureInput) => onFailure(failureInput),
        (S successInput) => onSuccess(successInput));
  }

  @override
  void setInput<I extends Input>(I input) {
    _entity = _entity.merge('success with input');
  }

  @override
  void subscribe(Type outputType, Function callback) {
    subscription = callback;
  }

  @override
  O getOutput<O extends Output>() {
    return output as O;
  }

  Future<void> doFakeRequest<O extends Output>(O output) async {
    await request(output,
        onFailure: (failure) => _entity.merge('failure'),
        onSuccess: (success) => _entity.merge('success'));
  }
}

class EntityFake extends Entity {
  final String value;
  EntityFake({this.value = 'initial'});

  @override
  List<Object?> get props => [value];

  EntityFake merge(newValue) => EntityFake(value: newValue);
}
