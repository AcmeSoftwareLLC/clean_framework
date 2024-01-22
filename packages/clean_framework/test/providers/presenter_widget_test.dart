import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final provider = UseCaseProvider((_) => TestUseCase());
void main() {
  testWidgets('Presenter initial load', (tester) async {
    final presenter = TestPresenter(
      builder: (TestViewModel viewModel) {
        return Text(viewModel.foo, key: const Key('foo'));
      },
    );

    await ProviderTester<dynamic>()
        .pumpWidget(tester, MaterialApp(home: presenter));

    expect(find.byKey(const Key('foo')), findsOneWidget);
    expect(find.text('INITIAL'), findsOneWidget);

    await tester.pump();
    expect(find.text('A'), findsOneWidget);

    expect(presenter.outputUpdateLogs, ['a']);

    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('B'), findsOneWidget);

    expect(presenter.outputUpdateLogs, ['a', 'b']);
  });

  testWidgets(
    'didUpdatePresenter test',
    (tester) async {
      final widget = MaterialApp(
        home: FutureBuilder<int>(
          initialData: 1,
          future: Future<int>.delayed(
            const Duration(milliseconds: 100),
            () => 2,
          ),
          builder: (context, snapshot) {
            return TestPresenter(
              count: snapshot.data,
              builder: (viewModel) =>
                  Text(viewModel.foo, key: const Key('foo')),
            );
          },
        ),
      );

      await ProviderTester<dynamic>().pumpWidget(tester, widget);

      final testPresenterFinder = find.byType(TestPresenter);
      expect(testPresenterFinder, findsOneWidget);

      var presenter = tester.widget<TestPresenter>(testPresenterFinder);
      expect(presenter.didUpdatePresenterLogs, isEmpty);

      await tester.pump(const Duration(milliseconds: 100));
      presenter = tester.widget<TestPresenter>(testPresenterFinder);
      expect(presenter.didUpdatePresenterLogs.first.previous, 1);
      expect(presenter.didUpdatePresenterLogs.first.next, 2);
    },
  );
}

class TestPresenter extends Presenter<TestViewModel, TestOutput, TestUseCase> {
  TestPresenter({required super.builder, super.key, this.count})
      : super(provider: provider);

  final int? count;

  final List<String> outputUpdateLogs = [];
  final List<PresenterData> didUpdatePresenterLogs = [];

  @override
  void onLayoutReady(BuildContext context, TestUseCase useCase) {
    super.onLayoutReady(context, useCase);
    useCase.fetch();
  }

  @override
  TestViewModel createViewModel(_, TestOutput output) =>
      TestViewModel.fromOutput(output);

  @override
  void onOutputUpdate(BuildContext context, TestOutput output) {
    super.onOutputUpdate(context, output);
    outputUpdateLogs.add(output.foo);
  }

  @override
  void didUpdatePresenter(
    BuildContext context,
    TestPresenter old,
    TestUseCase useCase,
  ) {
    super.didUpdatePresenter(context, old, useCase);
    didUpdatePresenterLogs.add(PresenterData(old.count, count));
  }
}

class TestUseCase extends UseCase<EntityFake> {
  TestUseCase()
      : super(
          useCaseState: const EntityFake(),
          transformers: [
            OutputTransformer.from((entity) => TestOutput(entity.value)),
          ],
        );

  Future<void> fetch() async {
    useCaseState = const EntityFake(value: 'a');

    await Future<void>.delayed(const Duration(milliseconds: 100));

    useCaseState = const EntityFake(value: 'b');
  }
}

class TestOutput extends DomainOutput {
  const TestOutput(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class TestViewModel extends ViewModel {
  const TestViewModel(this.foo);

  TestViewModel.fromOutput(TestOutput output) : foo = output.foo.toUpperCase();
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class PresenterData {
  PresenterData(this.previous, this.next);

  final int? previous;
  final int? next;
}
