import 'package:clean_framework/clean_framework.dart';

import 'package:clean_framework_http_example/features/home/adapter/pokemon_model.dart';

class PokemonSuccessInput extends SuccessDomainInput {
  const PokemonSuccessInput({required this.pokemons});

  final List<PokemonModel> pokemons;
}
