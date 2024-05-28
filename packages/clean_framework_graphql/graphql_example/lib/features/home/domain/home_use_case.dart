import 'dart:math';

import 'package:graphql_example/features/home/domain/home_domain_inputs.dart';
import 'package:graphql_example/features/home/domain/home_domain_models.dart';
import 'package:graphql_example/features/home/domain/home_entity.dart';
import 'package:clean_framework/clean_framework.dart';

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: const HomeEntity(),
          transformers: [
            HomeDomainToUIModelTransformer(),
          ],
        );

  Future<void> getPokemon() async {
    await request<HomeTestSuccessDomainInput>(
      HomeDomainToGatewayModel(
        id: Random().nextInt(100),
      ),
      onSuccess: (success) {
        return entity = entity.copyWith(
          pokemonId: success.pokemonModel.id,
          pokemonName: success.pokemonModel.name,
          pokemonOrder: success.pokemonModel.order,
          pokemonWeight: success.pokemonModel.weight,
          pokemonHeight: success.pokemonModel.height,
        );
      },
      onFailure: (failure) {
        return entity;
      },
    );
  }
}

class HomeDomainToUIModelTransformer
    extends DomainModelTransformer<HomeEntity, HomeDomainToUIModel> {
  @override
  HomeDomainToUIModel transform(HomeEntity entity) {
    return HomeDomainToUIModel(
      pokemonId: entity.pokemonId,
      pokemonName: entity.pokemonName,
      pokemonOrder: entity.pokemonOrder,
      pokemonWeight: entity.pokemonWeight,
      pokemonHeight: entity.pokemonHeight,
    );
  }
}
