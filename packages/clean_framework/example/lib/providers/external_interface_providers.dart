import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_external_interface.dart';
import 'package:clean_framework_example/providers/gateway_providers.dart';

final pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [
    pokemonCollectionGateway,
    pokemonProfileGateway,
    pokemonSpeciesGateway,
  ],
);
