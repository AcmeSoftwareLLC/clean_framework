import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/core/external_interface/pokemon_external_interface.dart';
import 'package:clean_framework_http_example/providers/gateway_providers.dart';

final ExternalInterfaceProvider<PokemonExternalInterface>
    pokemonExternalInterfaceProvider = ExternalInterfaceProvider(
  PokemonExternalInterface.new,
  gateways: [pokemonGatewayProvider],
);
