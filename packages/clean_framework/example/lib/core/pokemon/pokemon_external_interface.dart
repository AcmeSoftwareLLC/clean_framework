import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';
import 'package:dio/dio.dart';

class PokemonExternalInterface
    extends ExternalInterface<PokemonRequest, PokemonSuccessResponse> {
  PokemonExternalInterface({
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/'));

  final Dio _dio;

  @override
  void handleRequest() {
    on<GetPokemonRequest>(
      (request, send) async {
        final response = await _dio.get<Map<String, dynamic>>(
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
    return UnknownFailureResponse(error);
  }
}
