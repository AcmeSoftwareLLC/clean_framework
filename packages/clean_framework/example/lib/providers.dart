import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_species_gateway.dart';

final homeUseCaseProvider = UseCaseProvider.autoDispose(
  HomeUseCase.new,
  (bridge) {
    bridge.connect(
      profileUseCaseProvider,
      selector: (e) => e.name,
      (oldPokeName, pokeName) {
        if (oldPokeName != pokeName) {
          bridge.useCase.setInput(LastViewedPokemonInput(name: pokeName));
        }
      },
    );
  },
);

final profileUseCaseProvider = UseCaseProvider<ProfileEntity, ProfileUseCase>(
  ProfileUseCase.new,
);

final pokemonCollectionGateway = GatewayProvider(
  PokemonCollectionGateway.new,
  useCases: [homeUseCaseProvider],
);

final pokemonProfileGateway = GatewayProvider(
  PokemonProfileGateway.new,
  useCases: [profileUseCaseProvider],
);

final pokemonSpeciesGateway = GatewayProvider(
  PokemonSpeciesGateway.new,
  useCases: [profileUseCaseProvider],
);

final pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [
    pokemonCollectionGateway,
    pokemonProfileGateway,
    pokemonSpeciesGateway,
  ],
);
