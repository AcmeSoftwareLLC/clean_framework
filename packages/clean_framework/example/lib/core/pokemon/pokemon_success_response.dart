import 'package:clean_framework/clean_framework.dart';

class PokemonSuccessResponse extends SuccessResponse {
  const PokemonSuccessResponse({required this.data});

  final Map<String, dynamic> data;
}
