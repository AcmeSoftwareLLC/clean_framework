import 'package:graphql_example/features/home/domain/home_use_case.dart';
import 'package:graphql_example/features/home/external_interface/home_gateway.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';

final homeUseCaseProvider = UseCaseProvider(
  HomeUseCase.new,
);

final homeGatewayProvider = GatewayProvider(
  HomeGateway.new,
  useCases: [
    homeUseCaseProvider,
  ],
);

final graphQlExternalInterfaceProvider = ExternalInterfaceProvider(
  () => GraphQLExternalInterface.withService(
    service: GraphQLService(
      endpoint: 'https://beta.pokeapi.co/graphql/v1beta',
    ),
  ),
  gateways: [
    homeGatewayProvider,
  ],
);
