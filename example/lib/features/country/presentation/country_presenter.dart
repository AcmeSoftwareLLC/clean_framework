import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/country/domain/country_use_case.dart';
import 'package:clean_framework_example/features/country/domain/country_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter/material.dart';

class CountryPresenter
    extends Presenter<CountryViewModel, CountryUIOutput, CountryUseCase> {
  CountryPresenter({required PresenterBuilder<CountryViewModel> builder})
      : super(
          builder: builder,
          provider: countryUseCaseProvider,
        );

  @override
  void onLayoutReady(BuildContext context, CountryUseCase useCase) {
    useCase.fetchCountries();
  }

  @override
  CountryViewModel createViewModel(
    CountryUseCase useCase,
    CountryUIOutput output,
  ) {
    return CountryViewModel(
      isLoading: output.isLoading,
      countries: output.countries
          .map(
            (c) => SingleCountryViewModel(
              name: c.name,
              emoji: c.emoji,
              capital: c.capital,
            ),
          )
          .toList(growable: false),
      continents: output.continents,
      selectedContinentId: output.selectedContinentId,
      fetchCountries: useCase.fetchCountries,
    );
  }
}
