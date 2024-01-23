import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_domain_models.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/providers.dart';
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
      HomeUseCase useCase, HomeDomainToUIModel output) {
    return HomeViewModel(
      pokemons: output.pokemons,
      onSearch: (query) =>
          useCase.setInput(PokemonSearchDomainInput(name: query)),
      onRefresh: () => useCase.fetchPokemons(isRefresh: true),
      onRetry: useCase.fetchPokemons,
      isLoading: output.status == HomeStatus.loading,
      hasFailedLoading: output.status == HomeStatus.failed,
      loggedInEmail: output.loggedInEmail,
      errorMessage: output.errorMessage,
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
