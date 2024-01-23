import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Presenter tests |', () {
    testWidgets('displays widget correctly', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          child: MaterialApp(home: TestPresenter()),
        ),
      );

      expect(find.text('DEFAULT'), findsOneWidget);
    });

    testWidgets('family variant displays widget correctly', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          child: MaterialApp(home: TestPresenter.family(message: 'arg')),
        ),
      );

      expect(find.text('DEFAULT'), findsOneWidget);
    });

    testWidgets('output change trigger onOutputUpdate', (tester) async {
      await tester.pumpWidget(
        AppProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TestPresenter(),
            ),
          ),
        ),
      );

      expect(find.text('DEFAULT'), findsOneWidget);

      final clickFinder = find.text('CLICK');
      await tester.tap(clickFinder);
      await tester.pump();

      final fooFinder = find.text('FOO');

      expect(
        find.descendant(of: find.byType(Column), matching: fooFinder),
        findsOneWidget,
      );

      expect(
        find.descendant(of: find.byType(SnackBar), matching: fooFinder),
        findsOneWidget,
      );
    });

    testWidgets('didUpdatePresenter is triggered if presenter property changes',
        (tester) async {
      final messageNotifier = ValueNotifier('');

      await tester.pumpWidget(
        AppProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ValueListenableBuilder<String>(
                valueListenable: messageNotifier,
                builder: (context, message, _) {
                  return TestPresenter(message: message);
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('DEFAULT'), findsOneWidget);

      messageNotifier.value = 'BAR';
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: find.byType(SnackBar), matching: find.text('BAR')),
        findsOneWidget,
      );

      messageNotifier.dispose();
    });
  });
}

final _testUseCaseProvider = UseCaseProvider(TestUseCase.new);

final _testUseCaseProviderFamily =
    UseCaseProvider.family<TestEntity, TestUseCase, String>(
  (name) => TestUseCase(name: name),
);

class TestPresenter
    extends Presenter<TestViewModel, TestUIOutput, TestUseCase> {
  TestPresenter({
    super.key,
    WidgetBuilder? builder,
    this.message = '',
  }) : super(
          provider: _testUseCaseProvider,
          builder: builder ??
              (context) {
                final viewModel = ViewModelScope.of<TestViewModel>(context);
                return Column(
                  children: [
                    Text(viewModel.message),
                    ElevatedButton(
                      onPressed: () => viewModel.update('FOO'),
                      child: const Text('CLICK'),
                    ),
                  ],
                );
              },
        );

  TestPresenter.family({
    super.key,
    this.message = '',
  }) : super.family(
          family: _testUseCaseProviderFamily,
          arg: message,
          builder: (context) {
            final viewModel = ViewModelScope.of<TestViewModel>(context);
            return Column(
              children: [
                Text(viewModel.message),
                ElevatedButton(
                  onPressed: () => viewModel.update('FOO'),
                  child: const Text('CLICK'),
                ),
              ],
            );
          },
        );

  final String message;

  @override
  TestViewModel createViewModel(TestUseCase useCase, TestUIOutput output) {
    return TestViewModel(
      message: output.message,
      update: useCase.update,
    );
  }

  @override
  void didUpdatePresenter(
    BuildContext context,
    TestPresenter old,
    TestUseCase useCase,
  ) {
    super.didUpdatePresenter(context, old, useCase);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      useCase.update(message);
    });
  }

  @override
  void onOutputUpdate(BuildContext context, TestUIOutput output) {
    super.onOutputUpdate(context, output);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(output.message)),
    );
  }
}

class TestUIOutput extends DomainOutput {
  const TestUIOutput({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class TestViewModel extends ViewModel {
  const TestViewModel({
    required this.message,
    required this.update,
  });

  final String message;
  final ValueChanged<String> update;

  @override
  List<Object?> get props => [message];
}

class TestEntity extends Entity {
  const TestEntity({this.message = ''});

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  TestEntity copyWith({String? message}) {
    return TestEntity(message: message ?? this.message);
  }
}

class TestUseCase extends UseCase<TestEntity> {
  TestUseCase({this.name = ''})
      : super(
          entity: const TestEntity(message: 'DEFAULT'),
          transformers: [
            OutputTransformer.from(
              (entity) => TestUIOutput(message: entity.message),
            ),
          ],
        );

  final String name;

  void update(String message) {
    entity = entity.copyWith(message: message);
  }
}
