import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/domain/home_entity.dart';
import 'package:clean_framework_example/features/home/domain/home_ui_output.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter/material.dart';

class HomePresenter
    extends Presenter<HomeViewModel, HomeUIOutput, HomeUseCase> {
  HomePresenter({
    required super.builder,
  }) : super(provider: homeUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.fetchPokemons();
  }

  @override
  HomeViewModel createViewModel(HomeUseCase useCase, HomeUIOutput output) {
    return HomeViewModel(
      pokemons: output.pokemons,
      onSearch: (query) => useCase.setInput(PokemonSearchInput(name: query)),
      onRefresh: () => useCase.fetchPokemons(isRefresh: true),
      onRetry: useCase.fetchPokemons,
      isLoading: output.status == HomeStatus.loading,
      hasFailedLoading: output.status == HomeStatus.failed,
      loggedInEmail: output.loggedInEmail,
      errorMessage: output.errorMessage,
    );
  }

  @override
  void onOutputUpdate(BuildContext context, HomeUIOutput output) {
    if (output.isRefresh) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            output.status == HomeStatus.failed
                ? 'Sorry, failed refreshing pokemons!'
                : 'Refreshed pokemons successfully!',
          ),
        ),
      );
    }
  }
}
