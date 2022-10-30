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

    final successInput = TestSuccessInput('success');
    expect(SuccessInput() == successInput, isFalse);

    useCase.subscribe(TestDirectOutput, (output) {
      return Right<FailureInput, TestSuccessInput>(successInput);
    });

    expect(() => useCase.subscribe(TestDirectOutput, (_) {}), throwsStateError);

    await useCase.fetchDataImmediatelly();

    expect(useCase.entity, TestEntity(foo: 'success'));

    useCase.dispose();
  });

  test('UseCase subscription with delayed response on input filter', () async {
    final useCase = TestUseCase(TestEntity(foo: ''))
      ..subscribe(TestSubscriptionOutput, (output) {
        return Right<FailureInput, SuccessInput>(SuccessInput());
      });

    await useCase.fetchDataEventually();

    //no data change at this point
    expect(useCase.entity, TestEntity(foo: ''));

    useCase.setInput(TestSuccessInput('from input filter'));

    expect(useCase.entity, TestEntity(foo: 'from input filter'));

    useCase.dispose();
  });

  test('UseCase instance, request failure due to not having a subscription',
      () async {
    final useCase = TestUseCase(TestEntity(foo: ''));

    expect(() => useCase.getOutput<TestDirectOutput>(), throwsStateError);
    expect(
      () => useCase.setInput<FailureInput>(FailureInput()),
      throwsStateError,
    );

    useCase.dispose();
  });

  test('UseCase debounce test with immediate', () async {
    final useCase = DebouncedUseCase(immediate: true);

    int getCount() => useCase.entity.count;

    useCase.increment();
    expect(getCount(), equals(1));

    await Future<void>.delayed(const Duration(milliseconds: 110));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 90));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 75));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 50));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 60));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 105));
    useCase.increment();
    expect(getCount(), equals(3));

    await Future<void>.delayed(const Duration(milliseconds: 95));
    useCase.increment();
    expect(getCount(), equals(3));

    await Future<void>.delayed(const Duration(milliseconds: 105));
    useCase.increment();
    expect(getCount(), equals(4));

    useCase.dispose();
  });

  test('UseCase debounce test without immediate', () async {
    final useCase = DebouncedUseCase(immediate: false);

    int getCount() => useCase.entity.count;

    useCase.increment();
    expect(getCount(), equals(0));

    await Future<void>.delayed(const Duration(milliseconds: 40));
    useCase.increment();
    expect(getCount(), equals(0));

    await Future<void>.delayed(const Duration(milliseconds: 100));
    useCase.increment();
    expect(getCount(), equals(1));

    await Future<void>.delayed(const Duration(milliseconds: 110));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 90));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 75));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 50));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 60));
    useCase.increment();
    expect(getCount(), equals(2));

    await Future<void>.delayed(const Duration(milliseconds: 105));
    useCase.increment();
    expect(getCount(), equals(3));

    await Future<void>.delayed(const Duration(milliseconds: 95));
    useCase.increment();
    expect(getCount(), equals(3));

    await Future<void>.delayed(const Duration(milliseconds: 105));
    useCase.increment();
    expect(getCount(), equals(4));

    useCase.dispose();
  });
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase(TestEntity entity)
      : super(
          entity: entity,
          outputFilters: {
            TestOutput: (entity) => TestOutput(entity.foo),
          },
          inputFilters: {
            TestSuccessInput: (TestSuccessInput input, TestEntity entity) =>
                entity.merge(foo: input.foo),
          },
        );

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
  TestSuccessInput(this.foo);
  final String foo;
}

class TestDirectOutput extends Output {
  TestDirectOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSubscriptionOutput extends Output {
  TestSubscriptionOutput(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class TestEntity extends Entity {
  TestEntity({required this.foo});
  final String foo;

  @override
  List<Object?> get props => [foo];

  TestEntity merge({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestOutput extends Output {
  TestOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class DebouncedUseCase extends UseCase<DebouncedEntity> {
  DebouncedUseCase({required this.immediate})
      : super(entity: DebouncedEntity(count: 0));

  final bool immediate;

  void increment() {
    return debounce(
      action: () {
        entity = entity.merge(count: entity.count + 1);
      },
      tag: 'increment',
      duration: const Duration(milliseconds: 100),
      immediate: immediate,
    );
  }
}

class DebouncedEntity extends Entity {
  DebouncedEntity({required this.count});

  final int count;

  @override
  List<Object?> get props => [count];

  DebouncedEntity merge({int? count}) {
    return DebouncedEntity(count: count ?? this.count);
  }
}
