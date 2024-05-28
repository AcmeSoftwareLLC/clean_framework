import 'package:clean_framework/clean_framework.dart' hide Response;
import 'package:clean_framework_example_rest/core/dependency_providers.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_failure_response.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example_rest/core/pokemon/pokemon_success_response.dart';
import 'package:dio/dio.dart';

class PokemonExternalInterface
    extends ExternalInterface<PokemonRequest, PokemonSuccessResponse> {
  @override
  void handleRequest() {
    final client = locate(restClientProvider);

    on<GetPokemonRequest>(
      (request, send) async {
        final response = await client.get<Map<String, dynamic>>(
          request.resource,
          queryParameters: request.queryParams,
        );

        final data = response.data!;

        send(PokemonSuccessResponse(data: data));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.cancel:
          return PokemonFailureResponse(type: PokemonFailureType.serverError);
        case DioExceptionType.badResponse:
          final response = error.response!;
          return switch (response.statusCode) {
            401 => PokemonFailureResponse(
                type: PokemonFailureType.unauthorized,
                message: 'The request was not authorized.',
                errorData: response.data ?? {},
              ),
            404 => PokemonFailureResponse(
                type: PokemonFailureType.notFound,
                message: 'The requested resource was not found.',
                errorData: response.data ?? {},
              ),
            _ => PokemonFailureResponse(
                type: PokemonFailureType.unknown,
                message: 'An unknown error occurred.',
                errorData: response.data ?? {},
              ),
          };
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return PokemonFailureResponse(
            type: PokemonFailureType.unknown,
            message: error.message ?? '',
          );
      }
    }

    return PokemonFailureResponse(
      type: PokemonFailureType.unknown,
      message: error.toString(),
    );
  }
}
