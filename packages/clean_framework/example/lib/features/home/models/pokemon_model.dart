class PokemonModel {
  PokemonModel({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          imageUrl == other.imageUrl;

  @override
  int get hashCode => name.hashCode ^ imageUrl.hashCode;
}
