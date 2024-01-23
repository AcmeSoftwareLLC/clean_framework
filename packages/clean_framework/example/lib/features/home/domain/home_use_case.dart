import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/pokemon/pokemon_failure_response.dart';
import 'package:clean_framework_example/features/home/domain/home_state.dart';
import 'package:clean_framework_example/features/home/domain/home_domain_outputs.dart';
import 'package:clean_framework_example/features/home/external_interface/pokemon_collection_gateway.dart';
import 'package:clean_framework_example/features/home/models/pokemon_model.dart';

const _spritesBaseUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites';

class HomeUseCase extends UseCase<HomeState> {
  HomeUseCase()
      : super(
          entity: HomeState(),
          transformers: [
            HomeDomainToUIOutputTransformer(),
            PokemonSearchDomainInputTransformer(),
            LoggedInEmailDomainInputTransformer(),
          ],
        );

  Future<void> fetchPokemons({bool isRefresh = false}) async {
    if (!isRefresh) {
      entity = entity.copyWith(status: HomeStatus.loading);
    }

    final input = await getInput(PokemonCollectionDomainToGatewayOutput());
    switch (input) {
      case SuccessUseCaseInput(:PokemonCollectionSuccessDomainInput input):
        final pokemons = input.pokemonIdentities.map(_resolvePokemon);

        entity = entity.copyWith(
          pokemons: pokemons.toList(growable: false),
          status: HomeStatus.loaded,
          isRefresh: isRefresh,
        );
      case FailureUseCaseInput(:PokemonCollectionFailureDomainInput input):
        entity = entity.copyWith(
          errorMessage: switch (input.type) {
            PokemonFailureType.unauthorized =>
              'The request was not authorized.',
            PokemonFailureType.notFound =>
              'The requested resource was not found.',
            PokemonFailureType.serverError => 'An server error occurred.',
            PokemonFailureType.unknown => '',
          },
          status: HomeStatus.failed,
          isRefresh: isRefresh,
        );
      case _:
        entity = entity.copyWith(
          status: HomeStatus.failed,
          isRefresh: isRefresh,
        );
    }

    if (isRefresh) {
      entity = entity.copyWith(isRefresh: false, status: HomeStatus.loaded);
    }
  }

  PokemonModel _resolvePokemon(PokemonIdentity pokemon) {
    return PokemonModel(
      name: pokemon.name.toUpperCase(),
      imageUrl: '$_spritesBaseUrl/pokemon/other/dream-world/${pokemon.id}.svg',
    );
  }
}

class PokemonSearchDomainInput extends SuccessDomainInput {
  PokemonSearchDomainInput({required this.name});

  final String name;
}

class HomeDomainToUIOutputTransformer
    extends OutputTransformer<HomeState, HomeDomainToUIOutput> {
  @override
  HomeDomainToUIOutput transform(HomeState entity) {
    final filteredPokemons = entity.pokemons.where(
      (pokemon) {
        final pokeName = pokemon.name.toLowerCase();
        return pokeName.contains(entity.pokemonNameQuery.toLowerCase());
      },
    );

    return HomeDomainToUIOutput(
      pokemons: filteredPokemons.toList(growable: false),
      status: entity.status,
      isRefresh: entity.isRefresh,
      loggedInEmail: entity.loggedInEmail,
      errorMessage: entity.errorMessage,
    );
  }
}

class PokemonSearchDomainInputTransformer
    extends DomainInputTransformer<HomeState, PokemonSearchDomainInput> {
  @override
  HomeState transform(HomeState entity, PokemonSearchDomainInput input) {
    return entity.copyWith(pokemonNameQuery: input.name);
  }
}

class LoggedInEmailDomainInput extends SuccessDomainInput {
  LoggedInEmailDomainInput({required this.email});

  final String email;
}

class LoggedInEmailDomainInputTransformer
    extends DomainInputTransformer<HomeState, LoggedInEmailDomainInput> {
  @override
  HomeState transform(HomeState entity, LoggedInEmailDomainInput input) {
    return entity.copyWith(loggedInEmail: input.email);
  }
}
