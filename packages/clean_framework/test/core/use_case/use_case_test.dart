import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UseCase tests |', () {
    test('entity updates with setter', () {
      final useCase = TestUseCase();
      expect(useCase.entity, TestEntity());

      useCase.entity = useCase.entity.copyWith(foo: 'bar');
      expect(useCase.entity, TestEntity(foo: 'bar'));
    });

    test('entity updates with setInput', () {
      final useCase = TestUseCase();
      expect(useCase.entity, TestEntity());

      useCase.setInput(TestInput(foo: 'input'));
      expect(useCase.entity, TestEntity(foo: 'input'));
    });

    test(
      'entity update fails with setInput if no appropriate transformer is found',
      () {
        final useCase = TestUseCase();

        expect(useCase.entity, TestEntity());
        expect(
          () => useCase.setInput(NoTransformerTestInput(foo: 'input')),
          throwsStateError,
        );
      },
    );

    test(
      'getOutput() success',
      () {
        final useCase = TestUseCase();
        expect(useCase.entity, TestEntity());

        useCase.setInput(TestInput(foo: 'input'));

        final output = useCase.getOutput<TestOutput>();
        expect(output, TestOutput(foo: 'input'));
      },
    );

    test(
      'getOutput() fails when no appropriate transformer is found',
      () {
        final useCase = TestUseCase();
        expect(useCase.entity, TestEntity());

        useCase.setInput(TestInput(foo: 'input'));

        expect(useCase.getOutput<NoTransformerTestOutput>, throwsStateError);
      },
    );

    test(
      'successful request',
      () async {
        final useCase = TestUseCase();
        expect(useCase.entity, TestEntity());

        useCase.subscribe<TestGatewayOutput, TestSuccessInput>(
          (output) async {
            final out = output as TestGatewayOutput;
            return Either<FailureInput, TestSuccessInput>.right(
              TestSuccessInput(message: 'Hello ${out.name}!'),
            );
          },
        );

        await useCase.request<TestGatewayOutput, TestSuccessInput>(
          TestGatewayOutput(name: 'World'),
          onSuccess: (success) => TestEntity(foo: success.message),
          onFailure: (failure) => TestEntity(foo: 'failure'),
        );

        expect(useCase.entity, TestEntity(foo: 'Hello World!'));
      },
    );

    test(
      'request fails if there is no appropriate subscription present',
      () async {
        final useCase = TestUseCase();

        await useCase.request<TestGatewayOutput, TestSuccessInput>(
          TestGatewayOutput(name: 'World'),
          onSuccess: (success) => TestEntity(foo: success.message),
          onFailure: (failure) => TestEntity(foo: 'Hello Anonymous!'),
        );

        expect(useCase.entity, TestEntity(foo: 'Hello Anonymous!'));
      },
    );

    test(
      'clears resources on dispose',
      () async {
        final useCase = TestUseCase()..dispose();

        expect(() => useCase.entity, throwsStateError);
      },
    );
  });
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase()
      : super(
          entity: TestEntity(),
          transformers: [
            TestInputTransformer(),
            TestOutputTransformer(),
          ],
        );
}

class TestEntity extends Entity {
  TestEntity({this.foo = ''});

  final String foo;

  @override
  List<Object?> get props => [foo];

  @override
  TestEntity copyWith({String? foo}) => TestEntity(foo: foo ?? this.foo);
}

class TestInput extends Input {
  TestInput({required this.foo});

  final String foo;
}

class NoTransformerTestInput extends Input {
  NoTransformerTestInput({required this.foo});

  final String foo;
}

class TestOutput extends Output {
  TestOutput({required this.foo});

  final String foo;

  @override
  List<Object?> get props => [foo];
}

class TestGatewayOutput extends Output {
  TestGatewayOutput({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class TestSuccessInput extends SuccessInput {
  TestSuccessInput({required this.message});

  final String message;
}

class NoTransformerTestOutput extends Output {
  NoTransformerTestOutput({required this.foo});

  final String foo;

  @override
  List<Object?> get props => [foo];
}

class TestInputTransformer extends InputTransformer<TestEntity, TestInput> {
  @override
  TestEntity transform(TestEntity entity, TestInput input) {
    return entity.copyWith(foo: input.foo);
  }
}

class TestOutputTransformer extends OutputTransformer<TestEntity, TestOutput> {
  @override
  TestOutput transform(TestEntity entity) {
    return TestOutput(foo: entity.foo);
  }
}
