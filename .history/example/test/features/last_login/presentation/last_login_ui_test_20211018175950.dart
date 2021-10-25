import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_ui.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginISODateUI initial load', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginISODateUI(
          create: (builder) => PresenterIsoFake(builder: builder),
        ),
      ),
    );

    expect(find.text('Full Date'), findsOneWidget);
    expect(find.text('December 31, 2000'), findsOneWidget);
  });

  testWidgets('LastLoginISODateUI initial load', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginShortDateUI(
          create: (builder) => PresenterShortFake(builder: builder),
        ),
      ),
    );

    debugDumpApp();

    expect(find.text('Short Date'), findsOneWidget);
    expect(find.text('December 31, 2000'), findsOneWidget);
  });
}

class PresenterIsoFake extends LastLoginIsoDatePresenter {
  PresenterIsoFake({required PresenterBuilder<LastLoginISOViewModel> builder})
      : super(builder: builder);

  @override
  LastLoginUIOutput subscribe(_) =>
      LastLoginUIOutput(lastLogin: DateTime.parse('2000-12-31'));
}

class PresenterShortFake extends LastLoginShortDatePresenter {
  PresenterShortFake(
      {required PresenterBuilder<LastLoginShortViewModel> builder})
      : super(builder: builder);

  @override
  LastLoginUIOutput subscribe(_) =>
      LastLoginUIOutput(lastLogin: DateTime.parse('2000-12-31'));
}
