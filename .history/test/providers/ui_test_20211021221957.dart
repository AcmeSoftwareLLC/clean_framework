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

class PresenterFake extends Presenter {
  PresenterFake({required PresenterBuilder<TestViewModel> builder})
      : super(builder: builder);

  @override
  LastLoginUIOutput subscribe(_) =>
      LastLoginUIOutput(lastLogin: DateTime.parse('2000-12-31'));
}

class TestViewModel extends ViewModel {
  final String foo;

  TestViewModel(this.foo);

  @override
  List<Object?> get props => [foo];
}
