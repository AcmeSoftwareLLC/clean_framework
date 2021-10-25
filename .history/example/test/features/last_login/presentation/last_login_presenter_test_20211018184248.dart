import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginCTAPresenter fetch date', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake());

    await ProviderTester().pumpWidget(
      tester,
      LastLoginCTAPresenter(
          builder: (viewModel) {
            return Container();
          },
          provider: provider),
    );
    await tester.pumpAndSettle();

    expect(find.by)
  });
}

class LastLoginUseCaseFake extends Fake implements LastLoginUseCase {
  bool isCallbackInvoked = false;

  @override
  Future<void> fetchCurrentDate() async {
    isCallbackInvoked = true;
  }

  @override
  O getOutput<O extends Output>() {
    return LastLoginCTAUIOutput(isLoading: false) as O;
  }
}
