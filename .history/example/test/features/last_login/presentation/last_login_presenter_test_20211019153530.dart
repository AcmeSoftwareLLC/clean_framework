import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginCTAPresenter loading', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake(true));
    late LastLoginCTAViewModel viewModel;

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
    final useCase = LastLoginUseCaseFake(false);
    final provider = UseCaseProvider((_) => useCase);

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTAPresenter(
            builder: (viewModel) {
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
  final bool isLoading;
  bool isCallbackInvoked = false;

  LastLoginUseCaseFake(this.isLoading);

  @override
  Future<void> fetchCurrentDate() async {
    isCallbackInvoked = true;
  }

  @override
  O getOutput<O extends Output>() {
    return LastLoginCTAUIOutput(isLoading: isLoading) as O;
  }
}
