import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/features/home/domain/home_domain_models.dart';
import 'package:clean_framework_http_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_http_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_http_example/providers.dart';
import 'package:flutter/material.dart';

class HomePresenter extends Presenter<HomeViewModel, HomeDomainToUIModel, HomeUseCase> {
  HomePresenter({
    required super.builder,
    super.key,
  }) : super(provider: homeUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    unawaited(useCase.fetch());
  }

  @override
  HomeViewModel createViewModel(
    HomeUseCase useCase,
    HomeDomainToUIModel domainModel,
  ) {
    return HomeViewModel(
      pokemons: domainModel.pokemons
          .map(
            (p) => PokemonViewModel(
              name: p.name.toUpperCase(),
              imageUrl: p.url,
            ),
          )
          .toList(growable: false),
    );
  }
}
