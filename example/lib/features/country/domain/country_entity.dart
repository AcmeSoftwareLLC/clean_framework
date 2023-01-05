import 'package:clean_framework/clean_framework_providers.dart';

import 'country_model.dart';

class CountryEntity extends Entity {
  CountryEntity({
    this.isLoading = false,
    this.countries = const [],
    this.continents = const {},
    this.selectedContinentId = 'AS', // AS is country code for Asia.
    this.errorMessage = '',
  });

  final bool isLoading;
  final List<CountryInput> countries;
  final Map<String, String> continents;
  final String selectedContinentId;
  final String errorMessage;

  @override
  List<Object?> get props {
    return [
      isLoading,
      countries,
      continents,
      selectedContinentId,
      errorMessage,
    ];
  }

  CountryEntity merge({
    bool? isLoading,
    List<CountryInput>? countries,
    Map<String, String>? continents,
    String? continentId,
    String? errorMessage,
  }) {
    return CountryEntity(
      isLoading: isLoading ?? this.isLoading,
      countries: countries ?? this.countries,
      continents: continents ?? this.continents,
      selectedContinentId: continentId ?? this.selectedContinentId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
