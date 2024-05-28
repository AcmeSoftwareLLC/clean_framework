import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UseCase Transformer tests', () {
    test('output transformer', () {
      final useCase = TestUseCase()
        ..updateFoo('hello')
        ..updateBar(3);

      expect(useCase.debugEntity.foo, 'hello');
      expect(useCase.debugEntity.bar, 3);

      expect(useCase.getDomainModel<FooDomainModel>().foo, 'hello');
      expect(useCase.getDomainModel<BarDomainModel>().bar, 3);
    });

    test('input transformer', () {
      final useCase = TestUseCase()..setInput(const FooInput('hello'));

      expect(useCase.debugEntity.foo, 'hello');

      expect(useCase.getDomainModel<FooDomainModel>().foo, 'hello');
    });
  });
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

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase()
      : super(
          entity: const TestEntity(),
          transformers: [
            FooOutputTransformer(),
            FooInputTransformer(),
            DomainModelTransformer.from((entity) => BarDomainModel(entity.bar)),
          ],
        );

  void updateFoo(String foo) {
    entity = entity.copyWith(foo: foo);
  }

  void updateBar(int bar) {
    entity = entity.copyWith(bar: bar);
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

class FooOutputTransformer
    extends DomainModelTransformer<TestEntity, FooDomainModel> {
  @override
  FooDomainModel transform(TestEntity entity) {
    return FooDomainModel(entity.foo);
  }
}

class FooInputTransformer extends DomainInputTransformer<TestEntity, FooInput> {
  @override
  TestEntity transform(TestEntity entity, FooInput input) {
    return entity.copyWith(foo: input.foo);
  }
}
