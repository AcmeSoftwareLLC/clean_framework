import 'package:clean_framework/clean_framework_providers.dart';

class CountryModel extends Input {
  CountryModel({
    required this.name,
    required this.emoji,
    required this.capital,
  });

  final String name;
  final String emoji;
  final String capital;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '',
      capital: json['capital'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, emoji, capital];

  @override
  String toString() {
    return 'CountryModel{name: $name, emoji: $emoji, capital: $capital}';
  }
}
