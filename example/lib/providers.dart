import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart'
    hide FeatureState;
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';

import 'package:clean_framework_example/features/last_login/domain/last_login_entity.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/features/last_login/external_interface/last_login_date_gateway.dart';
import 'package:flutter/cupertino.dart';

import 'features/country/domain/country_entity.dart';
import 'features/country/domain/country_use_case.dart';
import 'features/country/external_interface/country_gateway.dart';
import 'features/random_cat/domain/random_cat_entity.dart';
import 'features/random_cat/domain/random_cat_use_case.dart';
import 'features/random_cat/external_interface/random_cat_gateway.dart';

ProvidersContext _providersContext = ProvidersContext();

ProvidersContext get providersContext => _providersContext;

@visibleForTesting
void resetProvidersContext([ProvidersContext? context]) {
  _providersContext = context ?? ProvidersContext();
}

final lastLoginUseCaseProvider =
    UseCaseProvider<LastLoginEntity, LastLoginUseCase>(
  (_) => LastLoginUseCase(),
);

final lastLoginGatewayProvider = GatewayProvider<LastLoginDateGateway>(
  (_) => LastLoginDateGateway(),
);

final countryUseCaseProvider = UseCaseProvider<CountryEntity, CountryUseCase>(
  (_) => CountryUseCase(),
);

final countryGatewayProvider = GatewayProvider<CountryGateway>(
  (_) => CountryGateway(),
);

final randomCatUseCaseProvider =
    UseCaseProvider<RandomCatEntity, RandomCatUseCase>(
  (_) => RandomCatUseCase(),
);

final randomCatGatewayProvider = GatewayProvider<RandomCatGateway>(
  (_) => RandomCatGateway(),
);

final firebaseExternalInterface = ExternalInterfaceProvider(
  (_) => FirebaseExternalInterface(
    firebaseClient: FirebaseClientFake({'date': '2021-10-07'}),
    gatewayConnections: [
      () => lastLoginGatewayProvider.getGateway(providersContext),
    ],
  ),
);

final graphQLExternalInterface = ExternalInterfaceProvider(
  (_) => GraphQLExternalInterface(
    link: 'https://countries.trevorblades.com',
    gatewayConnections: [
      () => countryGatewayProvider.getGateway(providersContext),
    ],
  ),
);

final restExternalInterface = ExternalInterfaceProvider(
  (_) => RestExternalInterface(
    baseUrl: 'https://thatcopy.pw',
    gatewayConnections: [
      () => randomCatGatewayProvider.getGateway(providersContext),
    ],
  ),
);

void loadProviders() {
  lastLoginUseCaseProvider.getUseCaseFromContext(providersContext);
  lastLoginGatewayProvider.getGateway(providersContext);
  firebaseExternalInterface.getExternalInterface(providersContext);
  graphQLExternalInterface.getExternalInterface(providersContext);
  restExternalInterface.getExternalInterface(providersContext);
}
