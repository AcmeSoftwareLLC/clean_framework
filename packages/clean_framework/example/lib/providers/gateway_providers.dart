import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example_rest/features/profile/external_interface/pokemon_profile_gateway.dart';
import 'package:clean_framework_example_rest/features/profile/external_interface/pokemon_species_gateway.dart';
import 'package:clean_framework_example_rest/providers/use_case_providers.dart';

final GatewayProvider<PokemonCollectionGateway> pokemonCollectionGateway = GatewayProvider(
  PokemonCollectionGateway.new,
  useCases: [homeUseCaseProvider],
);

final GatewayProvider<PokemonProfileGateway> pokemonProfileGateway = GatewayProvider(
  PokemonProfileGateway.new,
  useCases: [],
  families: [profileUseCaseFamily],
);

final GatewayProvider<PokemonSpeciesGateway> pokemonSpeciesGateway = GatewayProvider(
  PokemonSpeciesGateway.new,
  useCases: [],
  families: [profileUseCaseFamily],
);
