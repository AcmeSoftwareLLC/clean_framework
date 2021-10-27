import 'package:clean_framework/clean_framework_providers.dart';

class CountryInput extends Input {
  CountryInput({
    required this.name,
    required this.emoji,
    required this.capital,
  });

  final String name;
  final String emoji;
  final String capital;

  factory CountryInput.fromJson(Map<String, dynamic> json) {
    return CountryInput(
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '',
      capital: json['capital'] ?? '',
    );
  }

  @override
  String toString() {
    return 'CountryModel{name: $name, emoji: $emoji, capital: $capital}';
  }
}
