import 'package:clean_framework/clean_framework_core.dart';

class PokemonSuccessResponse extends SuccessResponse {
  PokemonSuccessResponse({required this.data});

  final Map<String, dynamic> data;
}
