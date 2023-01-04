import 'package:clean_framework/clean_framework_core.dart';
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
    useCase.init();
  }

  @override
  HomeViewModel createViewModel(HomeUseCase useCase, HomeUIOutput output) {
    return HomeViewModel(
      pokemons: output.pokemons,
      onSearch: (query) => useCase.setInput(PokemonSearchInput(name: query)),
    );
  }
}
