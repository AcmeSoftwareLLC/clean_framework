import 'package:clean_framework/clean_framework.dart';

class PokemonSpeciesModel {
  PokemonSpeciesModel({required this.descriptions});

  factory PokemonSpeciesModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    return PokemonSpeciesModel(
      descriptions: deserializer.getList(
        'flavor_text_entries',
        converter: PokemonDescriptionModel.fromJson,
      ),
    );
  }

  final List<PokemonDescriptionModel> descriptions;
}

class PokemonDescriptionModel {
  PokemonDescriptionModel({
    required this.text,
    required this.language,
  });

  factory PokemonDescriptionModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);
    final language = deserializer('language');

    return PokemonDescriptionModel(
      text: deserializer.getString('flavor_text'),
      language: language.getString('name'),
    );
  }

  final String text;
  final String language;
}
