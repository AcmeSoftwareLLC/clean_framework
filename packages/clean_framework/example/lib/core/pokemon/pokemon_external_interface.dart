import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/dependency_providers.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_request.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_success_response.dart';

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
    return UnknownFailureResponse(error);
  }
}
