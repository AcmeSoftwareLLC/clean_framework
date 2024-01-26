import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:theme_example/features/home/domain/home_domain_models.dart';
import 'package:theme_example/features/home/domain/home_use_case.dart';
import 'package:theme_example/features/home/presentation/home_view_model.dart';
import 'package:theme_example/providers.dart';

class HomePresenter
    extends Presenter<HomeViewModel, HomeDomainToUIModel, HomeUseCase> {
  HomePresenter({
    required super.builder,
    super.key,
  }) : super(provider: homeUseCaseProvider);

  @override
  HomeViewModel createViewModel(
      HomeUseCase useCase, HomeDomainToUIModel domainModel) {
    return HomeViewModel(
      appTheme: domainModel.appTheme,
      onThemeChange: useCase.updateTheme,
    );
  }

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.getTheme();
  }
}
