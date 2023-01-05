import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';

final homeUseCaseProvider = UseCaseProvider(HomeUseCase.new);

final profileUseCaseProvider = UseCaseProvider(ProfileUseCase.new);

final pokemonCollectionGateway = GatewayProvider(
  PokemonCollectionGateway.new,
  useCases: [homeUseCaseProvider],
);

final pokemonProfileGateway = GatewayProvider(
  PokemonProfileGateway.new,
  useCases: [profileUseCaseProvider],
);

final pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [
    pokemonCollectionGateway,
    pokemonProfileGateway,
  ],
);

void initializeExternalInterfaces(ProviderContainer container) {
  pokemonExternalInterfaceProvider.initializeFor(container);
}
