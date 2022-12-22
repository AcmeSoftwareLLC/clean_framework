import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

typedef UseCaseSubscription = Future<Either<FailureInput, SuccessInput>>
    Function(
  Output,
);

class UseCaseFake<S extends SuccessInput> extends Fake
    implements UseCase<EntityFake> {
  UseCaseFake({this.output});

  EntityFake _entity = EntityFake();
  late RequestSubscription subscription;
  S? successInput;
  final Output? output;

  @override
  EntityFake get entity => _entity;

  @override
  Future<void> request<O extends Output, I extends SuccessInput>(
    O output, {
    required InputCallback<EntityFake, I> onSuccess,
    required InputCallback<EntityFake, FailureInput> onFailure,
  }) async {
    final either = await subscription(output) as Either<FailureInput, I>;
    _entity = either.fold(onFailure, onSuccess);
  }

  @override
  void setInput<T extends Input>(T input) {
    _entity = _entity.merge('success with input');
  }

  @override
  void subscribe<O extends Output, I extends Input>(
    RequestSubscription<I> subscription,
  ) {
    this.subscription = subscription;
  }

  Future<void> doFakeRequest<O extends Output>(O output) async {
    await request(
      output,
      onFailure: (failure) => _entity.merge('failure'),
      onSuccess: (success) {
        successInput = success as S?;
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
