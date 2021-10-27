import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginCTAPresenter loading', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake(true));

    await ProviderTester().pumpWidget(
      tester,
      MaterialApp(
        home: LastLoginCTAPresenter(
            builder: (viewModel) {
              return viewModel.isLoading ? Text('loading') : Text('idle');
            },
            provider: provider),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('loading'), findsOneWidget);
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
    return LastLoginCTAUIOutput(isLoading: false) as O;
  }
}
