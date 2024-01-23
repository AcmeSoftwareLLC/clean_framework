import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

typedef UseCaseSubscription
    = Future<Either<FailureDomainInput, SuccessDomainInput>> Function(
  DomainOutput,
);

class UseCaseFake<S extends SuccessDomainInput> extends Fake
    implements UseCase<EntityFake> {
  UseCaseFake({this.output});

  EntityFake _entity = const EntityFake();
  late RequestSubscription subscription;
  S? successInput;
  final DomainOutput? output;

  @override
  EntityFake get entity => _entity;

  @override
  Future<void> request<I extends SuccessDomainInput>(
    DomainOutput output, {
    required InputCallback<EntityFake, I> onSuccess,
    required InputCallback<EntityFake, FailureDomainInput> onFailure,
  }) async {
    final either = await subscription(output) as Either<FailureDomainInput, I>;
    _entity = either.fold(onFailure, onSuccess);
  }

  @override
  void setInput<T extends DomainInput>(T input) {
    _entity = _entity.copyWith(value: 'success with input');
  }

  @override
  void subscribe<O extends DomainOutput, I extends DomainInput>(
    RequestSubscription<O, I> subscription,
  ) {
    this.subscription = (output) => subscription(output as O);
  }

  Future<void> doFakeRequest<O extends DomainOutput>(O output) async {
    await request(
      output,
      onFailure: (failure) => _entity.copyWith(value: 'failure'),
      onSuccess: (success) {
        successInput = success as S?;
        return _entity.copyWith(value: 'success');
      },
    );
  }
}

class EntityFake extends Entity {
  const EntityFake({this.value = 'initial'});

  final String value;

  @override
  List<Object?> get props => [value];

  @override
  EntityFake copyWith({String? value}) {
    return EntityFake(value: value ?? this.value);
  }
}
