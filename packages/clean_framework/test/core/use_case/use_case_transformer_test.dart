import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestUseCase useCase;

  group('UseCase | transformer tests |', () {
    setUp(() {
      return useCase = TransformerTestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('output transformer', () {
      useCase
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.debugUseCaseState.foo, 'hello');
      expect(useCase.debugUseCaseState.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.debugUseCaseState.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });

  group('UseCase | inline transformer tests |', () {
    setUp(() {
      return useCase = InlineTransformerTestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('output transformer', () {
      useCase
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.debugUseCaseState.foo, 'hello');
      expect(useCase.debugUseCaseState.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.debugUseCaseState.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });
}

abstract class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({super.transformers}) : super(useCaseState: const TestEntity());

  void updateFoo(String foo) {
    useCaseState = useCaseState.copyWith(foo: foo);
  }

  void updateBar(int bar) {
    useCaseState = useCaseState.copyWith(bar: bar);
  }
}

class TransformerTestUseCase extends TestUseCase {
  TransformerTestUseCase()
      : super(
          transformers: [
            FooOutputTransformer(),
            BarOutputTransformer(),
            FooInputTransformer(),
          ],
        );
}

class InlineTransformerTestUseCase extends TestUseCase {
  InlineTransformerTestUseCase()
      : super(
          transformers: [
            OutputTransformer.from((entity) => FooOutput(entity.foo)),
            OutputTransformer.from((entity) => BarOutput(entity.bar)),
            DomainInputTransformer<TestEntity, FooInput>.from(
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );
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

class BarOutputTransformer extends OutputTransformer<TestEntity, BarOutput> {
  @override
  BarOutput transform(TestEntity entity) {
    return BarOutput(entity.bar);
  }
}

class FooInputTransformer extends DomainInputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
