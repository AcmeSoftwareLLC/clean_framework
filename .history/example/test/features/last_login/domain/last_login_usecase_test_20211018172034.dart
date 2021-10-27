import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UseCase initial UI output', () {
    final useCase = LastLoginUseCase();
    final output = useCase.getOutput<LastLoginUIOutput>();
    expect(output, LastLoginUIOutput(lastLogin: DateTime.parse('1900-01-01')));

    final ctaOutput = useCase.getOutput<LastLoginCTAUIOutput>();
    expect(ctaOutput, LastLoginCTAUIOutput(isLoading: false));
  });
}
