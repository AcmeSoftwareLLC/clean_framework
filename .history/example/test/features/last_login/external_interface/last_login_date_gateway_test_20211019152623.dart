import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/tests/use_case_fake.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/external_interface/last_login_date_gateway.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

final context = ProvidersContext();

void main() {
  test('LastLoginDateGateway success', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = LastLoginDateGateway(context: context, provider: provider);

    gateway.transport = (request) async =>
        Right(FirebaseSuccessResponse({'date': '2000-01-01'}));

    //expect(useCase.subscription(LastLoginDateOutput(), ))

    await useCase.doFakeRequest(LastLoginDateOutput());

    expect(
        useCase.successInput, LastLoginDateInput(DateTime.parse('2000-01-01')));

    expect(useCase.entity, EntityFake(value: 'success'));
  });

  test('LastLoginDateGateway failure on yield output', () async {
    final useCase = UseCaseFake();
    final provider = UseCaseProvider((_) => useCase);
    var gateway = LastLoginDateGateway(context: context, provider: provider);

    gateway.transport = (request) async => Left(FailureResponse());

    await useCase.doFakeRequest(LastLoginDateOutput());

    expect(useCase.entity, EntityFake(value: 'failure'));
  });
}
