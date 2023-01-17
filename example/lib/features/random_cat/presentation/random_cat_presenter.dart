import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:example/features/random_cat/domain/random_cat_use_case.dart';
import 'package:example/features/random_cat/domain/random_cat_view_model.dart';
import 'package:example/providers.dart';
import 'package:flutter/material.dart';

class RandomCatPresenter
    extends Presenter<RandomCatViewModel, RandomCatUIOutput, RandomCatUseCase> {
  RandomCatPresenter({required PresenterBuilder<RandomCatViewModel> builder})
      : super(
          builder: builder,
          provider: randomCatUseCaseProvider,
        );

  @override
  void onLayoutReady(BuildContext context, RandomCatUseCase useCase) {
    useCase.fetch();
  }

  @override
  RandomCatViewModel createViewModel(
    RandomCatUseCase useCase,
    RandomCatUIOutput output,
  ) {
    return RandomCatViewModel(
      isLoading: output.isLoading,
      id: output.id,
      url: output.url,
      fetch: useCase.fetch,
    );
  }
}
