import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  uiTest(
    'LastLogin',
    context: ProvidersContext(),
    builder: () => TestUI(),
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    wrapWithMaterialApp: true,
    screenSize: Size(800, 600),
    localizationDelegates: [],
  );
}

class TestUI extends UI<TestViewModel> {
  @override
  Widget build(BuildContext context, TestViewModel viewModel) {
    return Text(viewModel.foo);
  }

  @override
  Presenter<ViewModel, Output, UseCase<Entity>> create(
      PresenterBuilder<TestViewModel> builder) {
    return PresenterFake(builder: builder);
  }
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
