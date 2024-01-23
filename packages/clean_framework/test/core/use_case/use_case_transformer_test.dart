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

      expect(useCase.debugEntity.foo, 'hello');
      expect(useCase.debugEntity.bar, 3);

      expect(useCase.getOutput<FooDomainModel>().foo, 'hello');
      expect(useCase.getOutput<BarDomainModel>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.debugEntity.foo, 'hello');

      expect(useCase.getOutput<FooDomainModel>().foo, 'hello');
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

      expect(useCase.debugEntity.foo, 'hello');
      expect(useCase.debugEntity.bar, 3);

      expect(useCase.getOutput<FooDomainModel>().foo, 'hello');
      expect(useCase.getOutput<BarDomainModel>().bar, 3);
    });

    test('input transformer', () {
      useCase.setInput(const FooInput('hello'));

      expect(useCase.debugEntity.foo, 'hello');

      expect(useCase.getOutput<FooDomainModel>().foo, 'hello');
    });
  });
}

abstract class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({super.transformers}) : super(entity: const TestEntity());

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
            FooDomainModelTransformer(),
            BarDomainModelTransformer(),
            FooDomainInputTransformer(),
          ],
        );
}

class InlineTransformerTestUseCase extends TestUseCase {
  InlineTransformerTestUseCase()
      : super(
          transformers: [
            DomainModelTransformer.from((entity) => FooDomainModel(entity.foo)),
            DomainModelTransformer.from((entity) => BarDomainModel(entity.bar)),
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

class FooInput extends SuccessDomainInput {
  const FooInput(this.foo);
  final String foo;
}

class FooDomainModel extends DomainModel {
  const FooDomainModel(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class BarDomainModel extends DomainModel {
  const BarDomainModel(this.bar);
  final int bar;

  @override
  List<Object?> get props => [bar];
}

class FooDomainModelTransformer
    extends DomainModelTransformer<TestEntity, FooDomainModel> {
  @override
  FooDomainModel transform(TestEntity entity) {
    return FooDomainModel(entity.foo);
  }
}

class BarDomainModelTransformer
    extends DomainModelTransformer<TestEntity, BarDomainModel> {
  @override
  BarDomainModel transform(TestEntity entity) {
    return BarDomainModel(entity.bar);
  }
}

class FooDomainInputTransformer
    extends DomainInputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
