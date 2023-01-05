import 'package:example/features/country/domain/country_entity.dart';
import 'package:example/features/country/domain/country_model.dart';
import 'package:example/features/country/domain/country_use_case.dart';
import 'package:example/providers.dart';
import 'package:flutter_test/flutter_test.dart';

final continents = {
  'Africa': 'AF',
  'Antarctica': 'AN',
  'Asia': 'AS',
  'Europe': 'EU',
  'North America': 'NA',
  'Oceania': 'OC',
  'South America': 'SA',
};

void main() {
  CountryUseCase getCountryUseCase() {
    return countryUseCaseProvider.getUseCaseFromContext(
      providersContext,
    );
  }

  setUp(() {
    resetProvidersContext();
    graphQLExternalInterface.getExternalInterface(providersContext);
  });

  group('CountryUseCase tests :: ', () {
    test('fetches countries for default continent successfully', () async {
      final useCase = getCountryUseCase();

      expect(
        useCase.entity,
        CountryEntity(
          isLoading: false,
          countries: [],
          continents: continents,
        ),
      );

      expectLater(
        useCase.stream,
        emitsInOrder(
          [
            CountryEntity(isLoading: true, continents: continents),
            isA<CountryEntity>()
                .having((e) => e.isLoading, 'isLoading', isFalse)
                .having(
                  (e) => e.countries,
                  'countries',
                  isA<List<CountryInput>>()
                      .having(
                        (countries) => countries[35].name,
                        '36th country name',
                        'Nepal',
                      )
                      .having(
                        (countries) => countries.length,
                        'number of Asian countries',
                        52,
                      ),
                ),
          ],
        ),
      );

      await useCase.fetchCountries();
      useCase.dispose();
    });

    test('fetches countries for specified continent successfully', () async {
      final useCase = getCountryUseCase();

      expect(
        useCase.entity,
        CountryEntity(
          isLoading: false,
          countries: [],
          continents: continents,
        ),
      );

      expectLater(
        useCase.stream,
        emitsInOrder(
          [
            CountryEntity(isLoading: true, continents: continents),
            isA<CountryEntity>()
                .having((e) => e.isLoading, 'isLoading', isFalse)
                .having(
                  (e) => e.countries,
                  'countries',
                  isA<List<CountryInput>>()
                      .having(
                        (countries) => countries[37].name,
                        '38th country name',
                        'United States',
                      )
                      .having(
                        (countries) => countries.length,
                        'number of North American countries',
                        41,
                      ),
                ),
          ],
        ),
      );

      await useCase.fetchCountries(continentId: 'NA');
      useCase.dispose();
    });
  });
}
