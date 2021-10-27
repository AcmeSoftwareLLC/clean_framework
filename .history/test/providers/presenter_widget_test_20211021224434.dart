import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/tests/use_case_fake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

final provider = UseCaseProvider((_) => TestUseCase());
void main() {
  testWidgets('Presenter initial load', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: TestPresenter(builder: (TestViewModel viewModel) {
          return Text(viewModel.foo, key: Key('foo'));
        }),
      ),
    );

    expect(find.byKey(Key('foo')), findsOneWidget);
    expect(find.text('BAR'), findsOneWidget);
  });
}

class TestPresenter extends Presenter<TestViewModel, TestOutput, UseCaseFake> {
  TestPresenter({required PresenterBuilder<TestViewModel> builder})
      : super(provider: provider, builder: builder);

  @override
  TestViewModel createViewModel(_, output) => TestViewModel.fromOutput(output);
}

class TestUseCase extends UseCase<EntityFake> {
  TestUseCase() : super(entity: EntityFake());

  @override
  O getOutput<O extends Output>() {
    return TestOutput('bar') as O;
  }
}

class TestOutput extends Output {
  final String foo;

  TestOutput(this.foo);

  @override
  List<Object?> get props => [foo];
}

class TestViewModel extends ViewModel {
  final String foo;

  TestViewModel(this.foo);

  TestViewModel.fromOutput(TestOutput output) : foo = output.foo.toUpperCase();

  @override
  List<Object?> get props => [foo];
}
