import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('UseCase initial UI output and fetchDate', () async {
    final useCase = LastLoginUseCase();

    // Subscription shortcut to mock the response from a Gateway
    final currentDate = DateTime.parse('2021-12-31');
    useCase.subscribe(
        LastLoginDateOutput, (_) => Right(LastLoginDateInput(currentDate)));

    var output = useCase.getOutput<LastLoginUIOutput>();
    expect(output, LastLoginUIOutput(lastLogin: DateTime.parse('1900-01-01')));

    var ctaOutput = useCase.getOutput<LastLoginCTAUIOutput>();
    expect(ctaOutput, LastLoginCTAUIOutput(isLoading: false));

    await useCase.fetchCurrentDate();

    output = useCase.getOutput<LastLoginUIOutput>();
    expect(output, LastLoginUIOutput(lastLogin: currentDate));

    ctaOutput = useCase.getOutput<LastLoginCTAUIOutput>();
    expect(ctaOutput, LastLoginCTAUIOutput(isLoading: false));
  });
}
