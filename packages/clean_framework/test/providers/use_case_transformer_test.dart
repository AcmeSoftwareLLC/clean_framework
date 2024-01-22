import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UseCase Transformer tests', () {
    test('output transformer', () {
      final useCase = TestUseCase()
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.debugUseCaseState.foo, 'hello');
      expect(useCase.debugUseCaseState.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      final useCase = TestUseCase()..setInput(const FooInput('hello'));

      expect(useCase.debugUseCaseState.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });
}

class TestSuccessInput extends SuccessDomainInput {
  const TestSuccessInput(this.foo);

  final String foo;
}

class TestEntity extends UseCaseState {
  const TestEntity({
    this.foo = '',
    this.bar = 0,
  });

  final String foo;
  final int bar;

  @override
  List<Object?> get props => [foo, bar];

  @override
  TestEntity copyWith({
    String? foo,
    int? bar,
  }) {
    return TestEntity(
      foo: foo ?? this.foo,
      bar: bar ?? this.bar,
    );
  }
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase()
      : super(
          useCaseState: const TestEntity(),
          transformers: [
            FooOutputTransformer(),
            FooInputTransformer(),
            OutputTransformer.from((entity) => BarOutput(entity.bar)),
          ],
        );

  void updateFoo(String foo) {
    useCaseState = useCaseState.copyWith(foo: foo);
  }

  void updateBar(int bar) {
    useCaseState = useCaseState.copyWith(bar: bar);
  }
}

class FooInput extends SuccessDomainInput {
  const FooInput(this.foo);
  final String foo;
}

class FooOutput extends DomainOutput {
  const FooOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class BarOutput extends DomainOutput {
  const BarOutput(this.bar);
  final int bar;

  @override
  List<Object?> get props => [bar];
}

class FooOutputTransformer extends OutputTransformer<TestEntity, FooOutput> {
  @override
  FooOutput transform(TestEntity entity) {
    return FooOutput(entity.foo);
  }
}

class FooInputTransformer extends DomainInputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
