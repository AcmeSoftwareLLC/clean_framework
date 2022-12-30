import 'package:clean_framework/clean_framework_providers.dart';
import 'package:example/features/last_login/domain/last_login_use_case.dart';
import 'package:example/features/last_login/presentation/last_login_presenter.dart';
import 'package:example/features/last_login/presentation/last_login_ui.dart';
import 'package:example/features/last_login/presentation/last_login_view_model.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLogin screen', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginUI(),
      ),
    );

    expect(find.byType(LastLoginISODateUI), findsOneWidget);
    expect(find.byType(LastLoginShortDateUI), findsOneWidget);
    expect(find.byType(LastLoginCTADateUI), findsOneWidget);
  });
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

  testWidgets('LastLoginShortDateUI initial load', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginShortDateUI(
          create: (builder) => PresenterShortFake(builder: builder),
        ),
      ),
    );

    expect(find.text('Short Date'), findsOneWidget);
    expect(find.text('12/31/2000'), findsOneWidget);
  });

  testWidgets('LastLoginCTADateUI loading', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTADateUI(
          create: (builder) => PresenterCTAFake(
            builder: builder,
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(Key('FetchDateButton')), findsNothing);
  });

  testWidgets('LastLoginCTADateUI idle', (tester) async {
    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTADateUI(
          create: (builder) => PresenterCTAFake(
            builder: builder,
            isLoading: false,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byKey(Key('FetchDateButton')), findsOneWidget);
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

class PresenterCTAFake extends LastLoginCTAPresenter {
  final bool isLoading;

  PresenterCTAFake(
      {required PresenterBuilder<LastLoginCTAViewModel> builder,
      required this.isLoading})
      : super(builder: builder);

  @override
  LastLoginCTAUIOutput subscribe(_) =>
      LastLoginCTAUIOutput(isLoading: isLoading);
}
