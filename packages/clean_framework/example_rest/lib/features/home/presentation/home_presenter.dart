import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_entity.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_domain_models.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example_rest/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:flutter/material.dart';

class HomePresenter
    extends Presenter<HomeViewModel, HomeDomainToUIModel, HomeUseCase> {
  HomePresenter({
    required super.builder,
  }) : super(provider: homeUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.fetchPokemons();
  }

  @override
  HomeViewModel createViewModel(
      HomeUseCase useCase, HomeDomainToUIModel domainModel) {
    return HomeViewModel(
      pokemons: domainModel.pokemons,
      onSearch: (query) =>
          useCase.setInput(PokemonSearchDomainInput(name: query)),
      onRefresh: () => useCase.fetchPokemons(isRefresh: true),
      onRetry: useCase.fetchPokemons,
      isLoading: domainModel.status == HomeStatus.loading,
      hasFailedLoading: domainModel.status == HomeStatus.failed,
      loggedInEmail: domainModel.loggedInEmail,
      errorMessage: domainModel.errorMessage,
    );
  }

  @override
  void onOutputUpdate(BuildContext context, HomeDomainToUIModel domainModel) {
    if (domainModel.isRefresh) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            domainModel.status == HomeStatus.failed
                ? 'Sorry, failed refreshing pokemons!'
                : 'Refreshed pokemons successfully!',
          ),
        ),
      );
    }
  }
}
