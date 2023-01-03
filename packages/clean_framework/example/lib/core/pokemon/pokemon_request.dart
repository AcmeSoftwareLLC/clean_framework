import 'package:clean_framework/clean_framework_core.dart';

abstract class PokemonRequest extends Request {
  Map<String, dynamic> get queryParams => {};
}

abstract class GetPokemonRequest extends PokemonRequest {
  String get resource;
}
