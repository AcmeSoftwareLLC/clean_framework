import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

typedef UseCaseSubscription
    = Future<Either<FailureDomainInput, SuccessDomainInput>> Function(
  DomainModel,
);

class UseCaseFake<S extends SuccessDomainInput> extends Fake
    implements UseCase<EntityFake> {
  UseCaseFake({this.domainModel});

  EntityFake _entity = const EntityFake();
  late RequestSubscription subscription;
  S? successInput;
  final DomainModel? domainModel;

  @override
  EntityFake get entity => _entity;

  @override
  Future<void> request<I extends SuccessDomainInput>(
    DomainModel domainModel, {
    required InputCallback<EntityFake, I> onSuccess,
    required InputCallback<EntityFake, FailureDomainInput> onFailure,
  }) async {
    final either =
        await subscription(domainModel) as Either<FailureDomainInput, I>;
    _entity = either.fold(onFailure, onSuccess);
  }

  @override
  void setInput<T extends DomainInput>(T input) {
    _entity = _entity.copyWith(value: 'success with input');
  }

  @override
  void subscribe<M extends DomainModel, I extends DomainInput>(
    RequestSubscription<M, I> subscription,
  ) {
    this.subscription = (output) => subscription(output as M);
  }

  Future<void> doFakeRequest<M extends DomainModel>(M domainModel) async {
    await request(
      domainModel,
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
