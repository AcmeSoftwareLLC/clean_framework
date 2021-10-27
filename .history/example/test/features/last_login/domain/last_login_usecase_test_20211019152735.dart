import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_entity.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final currentDate = DateTime.parse('2021-12-31');
  test('UseCase initial UI output and fetchDate', () async {
    final useCase = LastLoginUseCase();

    // Subscription shortcut to mock a successful response from a Gateway

    useCase.subscribe(
        LastLoginDateOutput,
        (_) => Right<FailureInput, LastLoginDateInput>(
            LastLoginDateInput(currentDate)));

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

  test('UseCase failure on fetch date', () async {
    final useCase = LastLoginUseCase();

    // Subscription shortcut to mock a failure in the response from a Gateway
    useCase.subscribe(LastLoginDateOutput,
        (output) { Left<FailureInput, LastLoginDateInput>(FailureInput());}

    await useCase.fetchCurrentDate();

    var output = useCase.getOutput<LastLoginUIOutput>();

    // on a failure, the usecase keeps the old data
    expect(output.lastLogin, DateTime.parse('1900-01-01'));
  });

  test('Entity merge', () {
    final entity = LastLoginEntity().merge(lastLogin: currentDate);
    expect(entity, LastLoginEntity(lastLogin: currentDate));

    //expect(LastLoginDateOutput(), LastLoginDateOutput());
  });
}
