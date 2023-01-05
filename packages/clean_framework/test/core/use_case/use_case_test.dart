import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TestUseCase useCase;

  group('UseCase tests |', () {
    setUp(() {
      useCase = TestUseCase();
    });

    tearDown(() {
      useCase.dispose();
    });

    test('entity updates with setter', () {
      expect(useCase.entity, TestEntity());

      useCase.entity = useCase.entity.copyWith(foo: 'bar');
      expect(useCase.entity, TestEntity(foo: 'bar'));
    });

    test('entity updates with setInput', () {
      expect(useCase.entity, TestEntity());

      useCase.setInput(TestInput(foo: 'input'));
      expect(useCase.entity, TestEntity(foo: 'input'));
    });

    test(
      'entity update fails w/ setInput if no appropriate transformer is found',
      () {
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
        expect(useCase.entity, TestEntity());

        useCase.setInput(TestInput(foo: 'input'));

        final output = useCase.getOutput<TestOutput>();
        expect(output, TestOutput(foo: 'input'));
      },
    );

    test(
      'getOutput() fails when no appropriate transformer is found',
      () {
        expect(useCase.entity, TestEntity());

        useCase.setInput(TestInput(foo: 'input'));

        expect(useCase.getOutput<NoTransformerTestOutput>, throwsStateError);
      },
    );

    test(
      'successful request',
      () async {
        expect(useCase.entity, TestEntity());

        useCase.subscribe<TestGatewayOutput, TestSuccessInput>(
          (output) async {
            final out = output as TestGatewayOutput;
            return Either.right(
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
      'throws if there is no appropriate subscription present',
      () async {
        expect(
          () => useCase.request<TestGatewayOutput, TestSuccessInput>(
            TestGatewayOutput(name: 'World'),
            onSuccess: (success) => TestEntity(),
            onFailure: (failure) => TestEntity(),
          ),
          throwsStateError,
        );
      },
    );

    test('throws error on duplicate subscription for same output', () {
      useCase.subscribe<TestGatewayOutput, TestSuccessInput>(
        (output) async {
          final out = output as TestGatewayOutput;
          return Either.right(
            TestSuccessInput(message: 'Hello ${out.name}!'),
          );
        },
      );

      expect(
        () => useCase.subscribe<TestGatewayOutput, TestSuccessInput>(
          (output) async {
            final out = output as TestGatewayOutput;
            return Either.right(
              TestSuccessInput(message: 'Hello ${out.name}!'),
            );
          },
        ),
        throwsStateError,
      );
    });

    group('debounce', () {
      test(
        'performs action immediately first '
        'and then only after the duration elapses',
        () async {
          useCase.entity = TestEntity(foo: '@');

          String getChar() => useCase.entity.foo;

          void increment() {
            useCase.debounce(
              action: () {
                useCase.entity = useCase.entity.copyWith(
                  foo: String.fromCharCode(getChar().codeUnitAt(0) + 1),
                );
              },
              tag: 'increment',
              duration: const Duration(milliseconds: 100),
            );
          }

          increment();
          expect(getChar(), equals('A'));

          await Future<void>.delayed(const Duration(milliseconds: 110));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 90));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 75));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 50));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 60));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 105));
          increment();
          expect(getChar(), equals('C'));

          await Future<void>.delayed(const Duration(milliseconds: 95));
          increment();
          expect(getChar(), equals('C'));

          await Future<void>.delayed(const Duration(milliseconds: 105));
          increment();
          expect(getChar(), equals('D'));
        },
      );

      test(
        'performs action only after the duration elapses; '
        'when immediate is false',
        () async {
          useCase.entity = TestEntity(foo: 'A');

          String getChar() => useCase.entity.foo;

          void increment() {
            useCase.debounce(
              action: () {
                useCase.entity = useCase.entity.copyWith(
                  foo: String.fromCharCode(getChar().codeUnitAt(0) + 1),
                );
              },
              tag: 'increment',
              duration: const Duration(milliseconds: 100),
              immediate: false,
            );
          }

          increment();
          expect(getChar(), equals('A'));

          await Future<void>.delayed(const Duration(milliseconds: 110));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 90));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 75));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 50));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 60));
          increment();
          expect(getChar(), equals('B'));

          await Future<void>.delayed(const Duration(milliseconds: 105));
          increment();
          expect(getChar(), equals('C'));

          await Future<void>.delayed(const Duration(milliseconds: 95));
          increment();
          expect(getChar(), equals('C'));

          await Future<void>.delayed(const Duration(milliseconds: 105));
          increment();
          expect(getChar(), equals('D'));
        },
      );
    });
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
