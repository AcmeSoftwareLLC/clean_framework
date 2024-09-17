import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/foundation.dart';

@immutable
class PokemonModel {
  const PokemonModel({
    required this.name,
    required this.url,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final data = json.deserialize;

    return PokemonModel(
      name: data.getString('name'),
      url: data.getString('url'),
    );
  }

  final String name;
  final String url;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PokemonModel &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            url == other.url;
  }

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
