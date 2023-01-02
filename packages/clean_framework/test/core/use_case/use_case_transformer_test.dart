import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestUseCase useCase;

  group('UseCase | transformer tests |', () {
    setUp(() {
      return useCase = TestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('output transformer', () {
      final useCase = TestUseCase()
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.entity.foo, 'hello');
      expect(useCase.entity.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      final useCase = TestUseCase()..setInput(FooInput('hello'));

      expect(useCase.entity.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });

  group('UseCase | inline transformer tests |', () {
    setUp(() {
      return useCase = TransformerTestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('output transformer', () {
      final useCase = TestUseCase()
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.entity.foo, 'hello');
      expect(useCase.entity.bar, 3);

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
      expect(useCase.getOutput<BarOutput>().bar, 3);
    });

    test('input transformer', () {
      final useCase = TestUseCase()..setInput(FooInput('hello'));

      expect(useCase.entity.foo, 'hello');

      expect(useCase.getOutput<FooOutput>().foo, 'hello');
    });
  });
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({
    List<UseCaseTransformer<TestEntity>>? transformers,
  }) : super(
          entity: TestEntity(),
          transformers: transformers ??
              [
                FooOutputTransformer(),
                FooInputTransformer(),
                OutputTransformer.from((entity) => BarOutput(entity.bar)),
              ],
        );

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
            OutputTransformer.from(
              (entity) => FooOutput(entity.foo),
            ),
            InputTransformer<TestEntity, FooInput>.from(
              (entity, input) => entity.copyWith(foo: input.foo),
            ),
          ],
        );
}

class TestSuccessInput extends SuccessInput {
  TestSuccessInput(this.foo);

  final String foo;
}

class TestEntity extends Entity {
  TestEntity({
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
  FooInput(this.foo);
  final String foo;
}

class FooOutput extends Output {
  FooOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class BarOutput extends Output {
  BarOutput(this.bar);
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

class FooInputTransformer extends InputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
