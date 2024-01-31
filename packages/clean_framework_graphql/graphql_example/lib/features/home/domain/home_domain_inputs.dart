import 'package:graphql_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework/clean_framework.dart';

class HomeTestSuccessDomainInput extends SuccessDomainInput {
  HomeTestSuccessDomainInput({
    required this.pokemonModel,
  });

  final PokemonModel pokemonModel;
}
