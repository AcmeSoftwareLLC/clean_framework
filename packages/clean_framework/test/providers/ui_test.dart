import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  uiTest(
    'LastLogin without setup',
    builder: TestUI.new,
    context: ProvidersContext(),
    parentBuilder: (child) => Container(child: child),
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    wrapWithMaterialApp: false,
    screenSize: const Size(800, 600),
  );

  uiTest(
    'LastLogin using router',
    builder: TestUI.new,
    context: ProvidersContext(),
    postFrame: (tester) async {
      await tester.pump();
    },
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    screenSize: const Size(800, 600),
  );

  uiTest(
    'LastLogin',
    builder: TestUI.new,
    context: ProvidersContext(),
    verify: (tester) async {
      expect(find.byType(type<PresenterFake>()), findsOneWidget);
      expect(find.text('bar'), findsOneWidget);
    },
    screenSize: const Size(800, 600),
  );
}

class TestUI extends UI<TestViewModel> {
  TestUI({super.key});

  @override
  Widget build(BuildContext context, TestViewModel viewModel) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Text(viewModel.foo),
    );
  }

  @override
  Presenter<ViewModel, DomainModel, UseCase<Entity>> create(
    PresenterBuilder<TestViewModel> builder,
  ) {
    return PresenterFake(builder: builder);
  }
}

class PresenterFake extends Presenter<TestViewModel, TestDomainModel, UseCase> {
  PresenterFake({required super.builder, super.key})
      : super(
          provider: UseCaseProvider((_) => UseCaseFake()),
        );

  @override
  TestDomainModel subscribe(_) => const TestDomainModel('bar');

  @override
  TestViewModel createViewModel(_, TestDomainModel output) {
    return TestViewModel(output.foo);
  }
}

class TestViewModel extends ViewModel {
  const TestViewModel(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}

class TestDomainModel extends DomainModel {
  const TestDomainModel(this.foo);
  final String foo;

  @override
  List<Object?> get props => [foo];
}
