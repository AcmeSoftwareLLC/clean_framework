import 'package:clean_framework/clean_framework.dart';
import 'package:example/features/country/domain/country_entity.dart';
import 'package:example/features/country/domain/country_model.dart';
import 'package:example/providers.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';
import 'package:flutter_test/flutter_test.dart';

import '../domain/country_use_case_test.dart';

void main() {
  group('CountryGateway tests :: ', () {
    test('fetches countries successfully', () async {
      final useCase = countryUseCaseProvider.getUseCaseFromContext(
        providersContext,
      );
      final gateway = countryGatewayProvider.getGateway(providersContext);

      gateway.transport = (request) async {
        return Either.right(
          GraphQLSuccessResponse(
            data: {
              'countries': [
                {
                  'name': 'Nepal',
                  'emoji': '🇳🇵',
                  'capital': 'Kathmandu',
                },
              ],
            },
          ),
        );
      };

      await useCase.fetchCountries();

      expect(
        useCase.entity,
        CountryEntity(
          continents: continents,
          countries: [
            CountryInput(
              name: 'Nepal',
              emoji: '🇳🇵',
              capital: 'Kathmandu',
            ),
          ],
        ),
      );
    });
  });
}
