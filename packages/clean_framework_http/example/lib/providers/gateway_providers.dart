import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/features/home/adapter/pokemon_gateway.dart';
import 'package:clean_framework_http_example/providers.dart';

final GatewayProvider<PokemonGateway> pokemonGatewayProvider = GatewayProvider(
  PokemonGateway.new,
  useCases: [homeUseCaseProvider],
);
