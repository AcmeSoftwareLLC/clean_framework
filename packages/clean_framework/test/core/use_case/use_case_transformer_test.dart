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

      expect(useCase.entity.foo, 'hello');
      expect(useCase.entity.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.entity.foo, 'hello');

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

      expect(useCase.entity.foo, 'hello');
      expect(useCase.entity.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.entity.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });

  group('UseCase | legacy filter tests |', () {
    setUp(() {
      return useCase = FilterTestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('output filter', () {
      useCase
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.entity.foo, 'hello');
      expect(useCase.entity.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input filter', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.entity.foo, 'hello');

      expect(useCase.getOutput<FooOutput>(), const FooOutput('hello'));
    });
  });
}

abstract class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({
    super.transformers,
    super.inputFilters,
    super.outputFilters,
  }) : super(entity: const TestEntity());

  void updateFoo(String foo) {
    entity = entity.copyWith(foo: foo);
  }

  void updateBar(int bar) {
    entity = entity.copyWith(bar: bar);
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
            InputTransformer<TestEntity, FooInput>.from(
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );
}

class FilterTestUseCase extends TestUseCase {
  FilterTestUseCase()
      : super(
          outputFilters: {
            FooOutput: (entity) => FooOutput(entity.foo),
            BarOutput: (entity) => BarOutput(entity.bar),
          },
          inputFilters: {
            FooInput: (input, entity) {
              return entity.copyWith(foo: (input as FooInput).foo);
            },
          },
        );
}

class TestSuccessInput extends SuccessInput {
  const TestSuccessInput(this.foo);

  final String foo;
}

class TestEntity extends Entity {
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

class FooInput extends Input {
  const FooInput(this.foo);
  final String foo;
}

class FooOutput extends Output {
  const FooOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class BarOutput extends Output {
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

class FooInputTransformer extends InputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
