import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/models/pokemon_profile_model.dart';
import 'package:clean_framework_example_rest/features/profile/models/pokemon_species_model.dart';

class PokemonProfileSuccessInput extends SuccessDomainInput {
  PokemonProfileSuccessInput({required this.profile});

  final PokemonProfileModel profile;
}

class PokemonSpeciesSuccessDomainInput extends SuccessDomainInput {
  PokemonSpeciesSuccessDomainInput({required this.species});

  final PokemonSpeciesModel species;
}
