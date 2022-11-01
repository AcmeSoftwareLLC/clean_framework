import 'package:clean_framework/clean_framework_providers.dart';
import 'package:equatable/equatable.dart';

class CountryInput extends Input with EquatableMixin {
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
  List<Object?> get props => [name, emoji, capital];

  @override
  String toString() {
    return 'CountryModel{name: $name, emoji: $emoji, capital: $capital}';
  }
}
