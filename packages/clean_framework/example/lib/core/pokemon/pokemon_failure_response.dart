import 'package:clean_framework/clean_framework.dart';

enum PokemonFailureType {
  serverError,
  unauthorized,
  notFound,
  unknown,
}

class PokemonFailureResponse extends TypedFailureResponse<PokemonFailureType> {
  const PokemonFailureResponse({
    required super.type,
    super.errorData = const {},
    super.message = '',
  });

  @override
  String toString() {
    return 'PokemonFailureResponse'
        '{type: $type, errorData: $errorData, message: $message}';
  }
}
