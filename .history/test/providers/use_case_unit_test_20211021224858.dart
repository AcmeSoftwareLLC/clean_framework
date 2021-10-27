import 'dart:async';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UseCase instance, request failure due to not having a subscription',
      () async {
    final useCase = TestUseCase(TestEntity(foo: ''));
    final viewModel = useCase.getOutput<TestOutput>();

    expect(viewModel.foo, '');

    await useCase.fetchDataImmediatelly();

    expect(useCase.entity, TestEntity(foo: 'failure'));

    useCase.dispose();
  });

  test('UseCase subscription with successful request', () async {
    final useCase = TestUseCase(TestEntity(foo: ''));

    useCase.subscribe(TestDirectOutput, (output) {
      return Right<FailureInput, TestSuccessInput>(TestSuccessInput('success'));
    });

    expect(() => useCase.subscribe(TestDirectOutput, (_) {}), throwsStateError);

    await useCase.fetchDataImmediatelly();

    expect(useCase.entity, TestEntity(foo: 'success'));

    useCase.dispose();
  });

  test('UseCase subscription with delayed response on input filter', () async {
    final useCase = TestUseCase(TestEntity(foo: ''));

    useCase.subscribe(TestSubscriptionOutput, (output) {
      return Right<FailureInput, SuccessInput>(SuccessInput());
    });

    await useCase.fetchDataEventually();

    //no data change at this point
    expect(useCase.entity, TestEntity(foo: ''));

    useCase.setInput(TestSuccessInput('from input filter'));

    expect(useCase.entity, TestEntity(foo: 'from input filter'));

    useCase.dispose();
  });
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity)
      : super(entity: entity, outputFilters: {
          TestOutput: (entity) => TestOutput(entity.foo),
        }, inputFilters: {
          TestSuccessInput: (TestSuccessInput input, TestEntity entity) =>
              entity.merge(foo: input.foo),
        });

  Future<void> fetchDataImmediatelly() async {
    await request<TestDirectOutput, TestSuccessInput>(
      TestDirectOutput('123'),
      onFailure: (_) => entity.merge(foo: 'failure'),
      onSuccess: (success) => entity.merge(foo: success.foo),
    );
  }

  Future<void> fetchDataEventually() async {
    await request<TestSubscriptionOutput, SuccessInput>(
      TestSubscriptionOutput('123'),
      onFailure: (_) => entity.merge(foo: 'failure'),
      onSuccess: (_) => entity, // no changes on the entity are needed,
      // the changes should happen on the inputFilter.
    );
  }
}

class TestSuccessInput extends SuccessInput {
  final String foo;

  TestSuccessInput(this.foo);

  @override
  List<Object?> get props => [foo];
}

class TestDirectOutput extends Output {
  final String id;

  TestDirectOutput(this.id);

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends Output {
  final String id;

  TestSubscriptionOutput(this.id);

  @override
  List<Object?> get props => [id];
}

class TestEntity extends Entity {
  final String foo;

  TestEntity({required this.foo});

  @override
  List<Object?> get props => [foo];

  TestEntity merge({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends Output {
  final String foo;

  TestOutput(this.foo);

  @override
  List<Object?> get props => [foo];
}
