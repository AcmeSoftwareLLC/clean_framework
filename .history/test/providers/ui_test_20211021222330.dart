import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLogin screen', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: TestUI(),
      ),
    );

    expect(find.text('bar'), findsOneWidget);
  });
}

class PresenterFake extends Presenter<TestViewModel, TestOutput, UseCase> {
  PresenterFake({required PresenterBuilder<TestViewModel> builder})
      : super(
            builder: builder, provider: UseCaseProvider((_) => UseCaseFake()));

  @override
  TestOutput subscribe(_) => TestOutput('bar');

  @override
  TestViewModel createViewModel(_, TestOutput output) {
    return TestViewModel(output.foo);
  }
}

class TestViewModel extends ViewModel {
  final String foo;

  TestViewModel(this.foo);

  @override
  List<Object?> get props => [foo];
}

class TestOutput extends Output {
  final String foo;

  TestOutput(this.foo);

  @override
  List<Object?> get props => [foo];
}
