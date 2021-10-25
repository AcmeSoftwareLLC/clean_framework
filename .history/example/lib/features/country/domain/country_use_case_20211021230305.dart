import 'package:clean_framework/clean_framework_providers.dart';

import 'country_entity.dart';
import 'country_model.dart';

class CountryUseCase extends UseCase<CountryEntity> {
  CountryUseCase()
      : super(
          entity: CountryEntity(
            continents: {
              'Africa': 'AF',
              'Antarctica': 'AN',
              'Asia': 'AS',
              'Europe': 'EU',
              'North America': 'NA',
              'Oceania': 'OC',
              'South America': 'SA',
            },
          ),
          outputFilters: {
            CountryUIOutput: (CountryEntity e) {
              return CountryUIOutput(
                isLoading: e.isLoading,
                countries: e.countries,
                continents: e.continents,
                selectedContinentId: e.selectedContinentId,
              );
            },
          },
        );

  Future<void> fetchCountries({
    String? continentId,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) entity = entity.merge(isLoading: true);

    final _continentId = continentId ?? entity.selectedContinentId;

    return request<CountryGatewayOutput, CountrySuccessInput>(
      CountryGatewayOutput(continentCode: _continentId),
      onSuccess: (successInput) => entity.merge(
        countries: successInput.countries,
        isLoading: false,
        continentId: _continentId,
      ),
      onFailure: (failure) => entity.merge(isLoading: false),
    );
  }
}

class CountryUIOutput extends Output {
  CountryUIOutput({
    required this.isLoading,
    required this.countries,
    required this.continents,
    required this.selectedContinentId,
  });

  final bool isLoading;
  final List<CountryInput> countries;
  final Map<String, String> continents;
  final String selectedContinentId;

  @override
  List<Object?> get props {
    return [isLoading, countries, continents, selectedContinentId];
  }
}

class CountryGatewayOutput extends Output {
  final String continentCode;

  CountryGatewayOutput({required this.continentCode});

  @override
  List<Object?> get props => [continentCode];
}

class CountrySuccessInput extends SuccessInput {
  final List<CountryInput> countries;

  CountrySuccessInput({required this.countries});

  factory CountrySuccessInput.fromJson(Map<String, dynamic> json) {
    return CountrySuccessInput(
      countries: List.of(json['countries'] ?? [])
          .map((c) => CountryInput.fromJson(c))
          .toList(growable: false),
    );
  }
}
