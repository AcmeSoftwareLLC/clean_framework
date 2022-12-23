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
          transformers: [
            OutputTransformer<CountryEntity, CountryUIOutput>.from(
              (e) {
                return CountryUIOutput(
                  isLoading: e.isLoading,
                  countries: e.countries,
                  continents: e.continents,
                  selectedContinentId: e.selectedContinentId,
                  errorMessage: e.errorMessage,
                );
              },
            ),
          ],
        );

  Future<void> fetchCountries({
    String? continentId,
    bool isRefresh = false,
  }) async {
    if (!isRefresh) entity = entity.merge(isLoading: true, errorMessage: '');

    final _continentId = continentId ?? entity.selectedContinentId;

    return request<CountryGatewayOutput, CountrySuccessInput>(
      CountryGatewayOutput(continentCode: _continentId),
      onSuccess: (successInput) => entity.merge(
        countries: successInput.countries,
        isLoading: false,
        continentId: _continentId,
        errorMessage: '',
      ),
      onFailure: (failure) => entity.merge(
        isLoading: false,
        errorMessage: failure.message,
      ),
    );
  }
}

class CountryUIOutput extends Output {
  CountryUIOutput({
    required this.isLoading,
    required this.countries,
    required this.continents,
    required this.selectedContinentId,
    required this.errorMessage,
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
