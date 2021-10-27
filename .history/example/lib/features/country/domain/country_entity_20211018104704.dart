import 'package:clean_framework/clean_framework_providers.dart';

import 'country_model.dart';

class CountryEntity extends Entity {
  CountryEntity({
    this.isLoading = false,
    this.countries = const [],
    this.continents = const {},
    this.selectedContinentId = 'AS', // AS is country code for Asia.
  });

  final bool isLoading;
  final List<CountryModel> countries;
  final Map<String, String> continents;
  final String selectedContinentId;

  @override
  List<Object?> get props {
    return [isLoading, countries, continents, selectedContinentId];
  }

  CountryEntity merge({
    bool? isLoading,
    List<CountryModel>? countries,
    Map<String, String>? continents,
    String? continentId,
  }) {
    return CountryEntity(
      isLoading: isLoading ?? this.isLoading,
      countries: countries ?? this.countries,
      continents: continents ?? this.continents,
      selectedContinentId: continentId ?? this.selectedContinentId,
    );
  }
}
