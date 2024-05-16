import 'package:graphql_example/features/home/domain/home_domain_models.dart';
import 'package:graphql_example/features/home/domain/home_use_case.dart';
import 'package:graphql_example/features/home/presentation/home_view_model.dart';
import 'package:graphql_example/providers.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class HomePresenter
    extends Presenter<HomeViewModel, HomeDomainToUIModel, HomeUseCase> {
  HomePresenter({
    required super.builder,
    super.key,
  }) : super(provider: homeUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.getPokemon();
  }

  @override
  HomeViewModel createViewModel(
      HomeUseCase useCase, HomeDomainToUIModel domainModel) {
    return HomeViewModel(
      pokemonId: domainModel.pokemonId,
      pokemonName: domainModel.pokemonName,
      pokemonOrder: domainModel.pokemonOrder,
      pokemonWeight: domainModel.pokemonWeight,
      pokemonHeight: domainModel.pokemonHeight,
      onRefreshAbility: () => useCase.getPokemon(),
    );
  }
}
