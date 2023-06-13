import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example/features/profile/external_interface/pokemon_species_gateway.dart';
import 'package:clean_framework_example/providers/use_case_providers.dart';

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
