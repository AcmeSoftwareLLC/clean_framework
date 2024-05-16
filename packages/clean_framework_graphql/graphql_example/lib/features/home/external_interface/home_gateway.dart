import 'package:graphql_example/features/home/domain/home_domain_inputs.dart';
import 'package:graphql_example/features/home/domain/home_domain_models.dart';
import 'package:graphql_example/features/home/models/pokemon_model.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';

class HomeGateway extends Gateway<HomeDomainToGatewayModel,
    HomeGetPokemonRequest, GraphQLSuccessResponse, HomeTestSuccessDomainInput> {
  @override
  HomeGetPokemonRequest buildRequest(HomeDomainToGatewayModel domainModel) {
    return HomeGetPokemonRequest(
      id: domainModel.id,
    );
  }

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @override
  HomeTestSuccessDomainInput onSuccess(GraphQLSuccessResponse response) {
    return HomeTestSuccessDomainInput(
      pokemonModel:
          PokemonModel.fromJson(response.data['pokemon_v2_pokemon'][0]),
    );
  }
}

class HomeGetPokemonRequest extends QueryGraphQLRequest {
  HomeGetPokemonRequest({
    required this.id,
  });

  final int id;

  @override
  String get document => '''
    query getPokemonQuery(\$id: Int) {
      pokemon_v2_pokemon(where: {id: {_eq: \$id} }) {
        id
        name
        order
        weight
        height
      }
    }
  ''';

  @override
  Map<String, dynamic>? get variables => {
        'id': id,
      };
}
