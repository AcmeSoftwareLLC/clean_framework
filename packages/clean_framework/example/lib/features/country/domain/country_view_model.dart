import 'package:clean_framework/clean_framework_providers.dart';

class CountryViewModel extends ViewModel {
  CountryViewModel({
    required this.isLoading,
    required this.countries,
    required this.continents,
    required this.selectedContinentId,
    required this.fetchCountries,
  });

  final bool isLoading;
  final List<SingleCountryViewModel> countries;
  final Map<String, String> continents;
  final String selectedContinentId;

  final Future<void> Function({
    String? continentId,
    bool isRefresh,
  }) fetchCountries;

  @override
  List<Object?> get props {
    return [isLoading, countries, continents, selectedContinentId];
  }
}

class SingleCountryViewModel extends ViewModel {
  SingleCountryViewModel({
    this.name = '',
    this.emoji = '',
    this.capital = '',
  });

  final String name;
  final String emoji;
  final String capital;

  @override
  List<Object?> get props => [name, emoji, capital];
}
