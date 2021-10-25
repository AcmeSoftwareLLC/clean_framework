import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginCTAPresenter fetch date', (tester) async {
    final provider = UseCaseProvider((_) => LastLoginUseCaseFake());

    await ProviderTester().pumpWidget(
        LastLoginCTAPresenter(builder: (viewModel) {}, provider: provider));
  });
}

class LastLoginUseCaseFake extends Fake implements LastLoginUseCase {
  bool isCallbackInvoked = false;

  @override
  Future<void> fetchCurrentDate() async {
    isCallbackInvoked = true;
  }
}
