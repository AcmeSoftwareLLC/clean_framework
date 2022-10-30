import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

typedef UseCaseSubscription = Future<Either<FailureInput, SuccessInput>>
    Function(
  Output,
);

class UseCaseFake<I extends SuccessInput> extends Fake
    implements UseCase<EntityFake> {
  UseCaseFake({this.output});

  EntityFake _entity = EntityFake();
  late Function subscription;
  I? successInput;
  final Output? output;

  @override
  EntityFake get entity => _entity;

  @override
  Future<void> request<O extends Output, S extends SuccessInput>(
    O output, {
    required EntityFake Function(S successInput) onSuccess,
    required EntityFake Function(FailureInput failureInput) onFailure,
  }) async {
    // ignore: avoid_dynamic_calls
    final either = await subscription(output) as Either<FailureInput, S>;
    _entity = either.fold(
      (FailureInput failureInput) => onFailure(failureInput),
      (S successInput) => onSuccess(successInput),
    );
  }

  @override
  void setInput<T extends Input>(T input) {
    _entity = _entity.merge('success with input');
  }

  @override
  void subscribe(Type outputType, Function callback) {
    subscription = callback;
  }

  Future<void> doFakeRequest<O extends Output>(O output) async {
    await request(
      output,
      onFailure: (failure) => _entity.merge('failure'),
      onSuccess: (success) {
        successInput = success as I?;
        return _entity.merge('success');
      },
    );
  }
}

class EntityFake extends Entity {
  EntityFake({this.value = 'initial'});
  final String value;

  @override
  List<Object?> get props => [value];

  EntityFake merge(String newValue) => EntityFake(value: newValue);
}
