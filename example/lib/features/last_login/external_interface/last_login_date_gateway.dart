import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/providers.dart';

class LastLoginDateGateway extends FirebaseGateway<LastLoginDateOutput,
    LastLoginDateRequest, LastLoginDateInput> {
  LastLoginDateGateway({ProvidersContext? context, UseCaseProvider? provider})
      : super(
            context: context ?? providersContext,
            provider: provider ?? lastLoginUseCaseProvider);

  @override
  LastLoginDateRequest buildRequest(LastLoginDateOutput output) {
    return LastLoginDateRequest();
  }

  @override
  LastLoginDateInput onSuccess(covariant FirebaseSuccessResponse response) {
    return LastLoginDateInput(
        DateTime.parse(response.json['date'] ?? '2000-01-01'));
  }
}

class LastLoginDateRequest extends FirebaseReadIdRequest {
  LastLoginDateRequest() : super(path: 'last_login', id: '12345');
}
