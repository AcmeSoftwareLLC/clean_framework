import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final _testUseCaseProvider = UseCaseProvider<TestEntity, TestUseCase>(
  TestUseCase.new,
  (bridge) {
    bridge.connect<TestEntity, TestUseCase, String>(
      _testUseCaseProvider3,
      selector: (e) => e.foo,
      (previous, next) {
        if (previous != next) {
          bridge.useCase.set(foo: 'bar3');
        }
      },
    );
  },
);

final _testUseCaseProvider2 =
    UseCaseProvider.autoDispose<TestEntity, TestUseCase>(
  TestUseCase.new,
  (bridge) {
    bridge.connect<TestEntity, TestUseCase, String>(
      _testUseCaseProvider,
      selector: (e) => e.foo,
      (previous, next) {
        if (previous != next) {
          bridge.useCase.set(foo: 'bar2');
        }
      },
    );
  },
);

final _testUseCaseProvider3 = UseCaseProvider<TestEntity, TestUseCase>(
  TestUseCase.new,
);

final _testUseCaseAutoDisposeFamily =
    UseCaseProvider.autoDispose.family<TestEntity, TestUseCase, String>(
  (name) => TestUseCase(name: name),
  (_) {},
);

final _testUseCaseFamily =
    UseCaseProvider.family<TestEntity, TestUseCase, String>(
  (name) => TestUseCase(name: name),
  (_) {},
);

void main() {
  group('UseCase Provider tests |', () {
    testWidgets('output subscription', (tester) async {
      var clicked = false;

      final widget = AppProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              expect(
                _testUseCaseProvider.subscribe<TestDomainModel>(ref),
                TestDomainModel(foo: clicked ? 'bar' : ''),
              );

              return ElevatedButton(
                onPressed: () {
                  clicked = true;

                  _testUseCaseProvider.getUseCase(ref).set(foo: 'bar');
                },
                child: const Text('CLICK'),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.tap(find.text('CLICK'));
      await tester.pump();
    });

    testWidgets('output subscription with auto dispose', (tester) async {
      var clicked = false;

      final widget = AppProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              expect(
                _testUseCaseProvider2.subscribe<TestDomainModel>(ref),
                TestDomainModel(foo: clicked ? 'bar' : ''),
              );

              return ElevatedButton(
                onPressed: () {
                  clicked = true;

                  _testUseCaseProvider2.getUseCase(ref).set(foo: 'bar');
                },
                child: const Text('CLICK'),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.tap(find.text('CLICK'));
      await tester.pump();
    });

    testWidgets('bridging providers', (tester) async {
      var clicked = false;
      var clicked3 = false;

      final widget = AppProviderScope(
        child: MaterialApp(
          home: Column(
            children: [
              Consumer(
                builder: (context, ref, _) {
                  expect(
                    _testUseCaseProvider2.subscribe<TestDomainModel>(ref),
                    TestDomainModel(foo: clicked ? 'bar2' : ''),
                  );

                  return ElevatedButton(
                    onPressed: () {
                      clicked = true;

                      _testUseCaseProvider.getUseCase(ref).set(foo: 'bar');
                    },
                    child: const Text('CLICK'),
                  );
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  expect(
                    _testUseCaseProvider.subscribe<TestDomainModel>(ref),
                    TestDomainModel(
                      foo: clicked3
                          ? 'bar3'
                          : clicked
                              ? 'bar'
                              : '',
                    ),
                  );

                  return ElevatedButton(
                    onPressed: () {
                      clicked3 = true;

                      _testUseCaseProvider3.getUseCase(ref).set(foo: 'bar');
                    },
                    child: const Text('CLICK3'),
                  );
                },
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.tap(find.text('CLICK'));
      await tester.pump();

      await tester.tap(find.text('CLICK3'));
      await tester.pump();
    });

    testWidgets('listen for output changes', (tester) async {
      final widget = AppProviderScope(
        child: MaterialApp(
          home: Consumer(
            builder: (context, ref, _) {
              _testUseCaseProvider.listen<TestDomainModel>(ref, (o, n) {
                expect(o, const TestDomainModel(foo: ''));
                expect(n, const TestDomainModel(foo: 'bar'));
              });

              return ElevatedButton(
                onPressed: () {
                  _testUseCaseProvider
                      .getUseCaseFromContext(context)
                      .set(foo: 'bar');
                },
                child: const Text('CLICK'),
              );
            },
          ),
        ),
      );

      await tester.pumpWidget(widget);

      await tester.tap(find.text('CLICK'));
      await tester.pump();
    });

    test('read using container', () {
      final container = ProviderContainer();

      final useCase = _testUseCaseProvider.read(container);

      expect(useCase, isA<TestUseCase>());
    });

    test('override use case provider', () {
      final container = ProviderContainer(
        overrides: [
          _testUseCaseProvider.overrideWith(NewTestUseCase()),
        ],
      );

      final useCase = _testUseCaseProvider.read(container);

      expect(useCase, isA<NewTestUseCase>());
    });

    test('override auto dispose use case provider', () {
      final container = ProviderContainer(
        overrides: [
          _testUseCaseProvider2.overrideWith(NewTestUseCase()),
        ],
      );

      final useCase = _testUseCaseProvider2().notifier.read(container);

      expect(useCase, isA<NewTestUseCase>());
    });
  });

  group('UseCase Provider Family tests |', () {
    test('use case creation', () {
      final container = ProviderContainer();

      final pikachuUseCase =
          _testUseCaseAutoDisposeFamily('Pikachu').read(container);
      final bulbasaurUseCase =
          _testUseCaseAutoDisposeFamily('Bulbasaur').read(container);

      expect(pikachuUseCase, isA<TestUseCase>());
      expect(bulbasaurUseCase, isA<TestUseCase>());

      expect(pikachuUseCase.name, 'Pikachu');
      expect(bulbasaurUseCase.name, 'Bulbasaur');
    });

    test('family creates new instance of use case for each arg', () {
      final container = ProviderContainer();

      var oneUseCase = _testUseCaseProvider.read(container);
      var twoUseCase = _testUseCaseProvider.read(container);

      expect(oneUseCase, equals(twoUseCase));

      oneUseCase = _testUseCaseFamily('1').read(container);
      twoUseCase = _testUseCaseFamily('2').read(container);

      expect(oneUseCase, isNot(equals(twoUseCase)));
    });

    test('family notifier', () {
      _testUseCaseAutoDisposeFamily.notifier.listen(
        expectAsync1((data) {
          expect(data.$2, 'test');
        }),
      );
      _testUseCaseFamily.notifier.listen(
        expectAsync1((data) {
          expect(data.$2, 'test');
        }),
      );

      _testUseCaseAutoDisposeFamily.init('test');
      _testUseCaseFamily.init('test');
    });
  });
}

class NewTestUseCase extends TestUseCase {}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({this.name = ''})
      : super(
          entity: const TestEntity(),
          transformers: [
            DomainModelTransformer.from((e) => TestDomainModel(foo: e.foo)),
          ],
        );

  final String name;

  void set({required String foo}) {
    entity = entity.copyWith(foo: foo);
  }
}

class TestEntity extends Entity {
  const TestEntity({this.foo = ''});

  final String foo;

  @override
  List<Object?> get props => [foo];

  @override
  TestEntity copyWith({String? foo}) {
    return TestEntity(foo: foo ?? this.foo);
  }
}

class TestDomainModel extends DomainModel {
  const TestDomainModel({required this.foo});

  final String foo;

  @override
  List<Object?> get props => [foo];
}
