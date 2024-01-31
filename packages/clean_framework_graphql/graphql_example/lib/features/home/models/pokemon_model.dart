import 'package:clean_framework/clean_framework.dart';

class PokemonModel extends Equatable {
  const PokemonModel({
    required this.id,
    required this.name,
    required this.order,
    required this.weight,
    required this.height,
  });

  final int id;
  final String name;
  final int order;
  final double weight;
  final double height;

  @override
  List<Object?> get props => [
        id,
        name,
        order,
        weight,
        height,
      ];

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    return PokemonModel(
      id: deserializer.getInt('id'),
      name: deserializer.getString('name'),
      order: deserializer.getInt('order'),
      weight: deserializer.getDouble('weight'),
      height: deserializer.getDouble('height'),
    );
  }
}
