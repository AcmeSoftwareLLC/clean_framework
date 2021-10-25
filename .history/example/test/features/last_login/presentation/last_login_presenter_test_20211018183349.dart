import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LastLoginCTAPresenter fetch date', (tester) async {
    await ProviderTester()
        .pumpWidget(LastLoginCTAPresenter(builder: (viewModel) {

        }));
  });
}
