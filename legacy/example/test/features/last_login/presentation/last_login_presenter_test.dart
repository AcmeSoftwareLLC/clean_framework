import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:example/features/last_login/domain/last_login_use_case.dart';
import 'package:example/features/last_login/presentation/last_login_presenter.dart';
import 'package:example/features/last_login/presentation/last_login_view_model.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginIsoDatePresenter loading', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake(
        LastLoginUIOutput(lastLogin: DateTime.parse('1900-01-01'))));

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginIsoDatePresenter(
            builder: (viewModel) {
              expect(
                  viewModel, LastLoginISOViewModel(isoDate: 'January 1, 1900'));
              return Text(viewModel.isoDate);
            },
            provider: provider),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('January 1, 1900'), findsOneWidget);
  });
  testWidgets('LastLoginShortDatePresenter', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake(
        LastLoginUIOutput(lastLogin: DateTime.parse('1900-01-01'))));

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginShortDatePresenter(
            builder: (viewModel) {
              expect(viewModel, LastLoginShortViewModel(shortDate: '1/1/1900'));
              return Text(viewModel.shortDate);
            },
            provider: provider),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('1/1/1900'), findsOneWidget);
  });
  testWidgets('LastLoginCTAPresenter loading', (tester) async {
    final provider = UseCaseProvider(
        (_) => LastLoginUseCaseFake(LastLoginCTAUIOutput(isLoading: true)));

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTAPresenter(
            builder: (viewModel) {
              expect(
                  viewModel,
                  LastLoginCTAViewModel(
                      isLoading: true, fetchCurrentDate: () {}));
              return viewModel.isLoading ? Text('loading') : Text('idle');
            },
            provider: provider),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('loading'), findsOneWidget);
  });

  testWidgets('LastLoginCTAPresenter fetch date', (tester) async {
    final useCase =
        LastLoginUseCaseFake(LastLoginCTAUIOutput(isLoading: false));
    final provider = UseCaseProvider((_) => useCase);

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTAPresenter(
            builder: (viewModel) {
              expect(
                  viewModel,
                  LastLoginCTAViewModel(
                      isLoading: false, fetchCurrentDate: () {}));

              return ElevatedButton(
                key: Key('button'),
                child: Text('button'),
                onPressed: viewModel.fetchCurrentDate,
              );
            },
            provider: provider),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key('button')));
    await tester.pumpAndSettle();

    expect(useCase.isCallbackInvoked, isTrue);
  });
}

class LastLoginUseCaseFake extends LastLoginUseCase {
  final Output output;
  bool isCallbackInvoked = false;

  LastLoginUseCaseFake(this.output);

  @override
  Future<void> fetchCurrentDate() async {
    isCallbackInvoked = true;
  }

  @override
  O getOutput<O extends Output>() {
    return output as O;
  }
}
