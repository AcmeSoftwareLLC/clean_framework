import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';

final homeUseCaseProvider = UseCaseProvider(HomeUseCase.new);

final pokemonCollectionGateway = GatewayProvider(
  PokemonCollectionGateway.new,
  useCases: [homeUseCaseProvider],
);

final pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [pokemonCollectionGateway],
);

void initializeExternalInterfaces(ProviderContainer container) {
  pokemonExternalInterfaceProvider.initializeFor(container);
}
