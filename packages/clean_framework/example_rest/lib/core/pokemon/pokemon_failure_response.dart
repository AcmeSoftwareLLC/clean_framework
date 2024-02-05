import 'package:clean_framework/clean_framework.dart';

enum PokemonFailureType {
  serverError,
  unauthorized,
  notFound,
  unknown,
}

class PokemonFailureResponse extends TypedFailureResponse<PokemonFailureType> {
  PokemonFailureResponse({
    required PokemonFailureType type,
    super.errorData = const {},
    super.message = '',
  }) : super(type: type);

  @override
  String toString() {
    return 'PokemonFailureResponse{type: $type, errorData: $errorData, message: $message}';
  }
}
