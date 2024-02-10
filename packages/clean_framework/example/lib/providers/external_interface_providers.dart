import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example_rest/providers/gateway_providers.dart';

final pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [
    pokemonCollectionGateway,
    pokemonProfileGateway,
    pokemonSpeciesGateway,
  ],
);
