import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:theme_example/features/home/domain/home_domain_models.dart';
import 'package:theme_example/features/home/domain/home_use_case.dart';
import 'package:theme_example/features/home/presentation/theme/home_theme_view_model.dart';
import 'package:theme_example/providers.dart';

class HomeThemePresenter extends Presenter<HomeThemeViewModel,
    HomeThemeDomainToUIModel, HomeUseCase> {
  HomeThemePresenter({
    required super.builder,
    super.key,
  }) : super(provider: homeUseCaseProvider);

  @override
  HomeThemeViewModel createViewModel(
      HomeUseCase useCase, HomeThemeDomainToUIModel domainModel) {
    return HomeThemeViewModel(
      appTheme: domainModel.appTheme,
    );
  }

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.getTheme();
  }
}
