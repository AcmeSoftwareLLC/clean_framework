import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final router = AppRouter(
    routes: [
      AppRoute(
        name: 'test',
        path: '/',
        builder: (_, __) => TestUI(),
      ),
    ],
    errorBuilder: (_, __) => Container(),
  );

  uiTest(
    'LastLogin without setup',
    builder: () => TestUI(),
    context: ProvidersContext(),
    parentBuilder: (child) => Container(child: child),
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    wrapWithMaterialApp: false,
    screenSize: Size(800, 600),
  );

  setupUITest(
    context: ProvidersContext(),
    router: router,
  );

  uiTest(
    'LastLogin using router',
    postFrame: (tester) async {
      await tester.pump();
    },
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    wrapWithMaterialApp: true,
    screenSize: Size(800, 600),
  );

  uiTest(
    'LastLogin',
    builder: () => TestUI(),
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    wrapWithMaterialApp: true,
    screenSize: Size(800, 600),
  );
}

class TestUI extends UI<TestViewModel> {
  @override
  Widget build(BuildContext context, TestViewModel viewModel) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(viewModel.foo),
    );
  }

  @override
  Presenter<ViewModel, Output, UseCase<Entity>> create(
    PresenterBuilder<TestViewModel> builder,
  ) {
    return PresenterFake(builder: builder);
  }
}

class PresenterFake extends Presenter<TestViewModel, TestOutput, UseCase> {
  PresenterFake({required PresenterBuilder<TestViewModel> builder})
      : super(
          builder: builder,
          provider: UseCaseProvider((_) => UseCaseFake()),
        );

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
