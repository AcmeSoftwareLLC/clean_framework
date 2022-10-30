import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework_example/features/country/domain/country_use_case.dart';
import 'package:clean_framework_example/providers.dart';

class CountryGateway extends GraphQLGateway<CountryGatewayOutput,
    CountryRequest, CountrySuccessInput> {
  CountryGateway()
      : super(
          context: providersContext,
          provider: countryUseCaseProvider,
        );

  @override
  CountryRequest buildRequest(CountryGatewayOutput output) {
    return CountryRequest(
      continentCode: output.continentCode,
    );
  }

  @override
  CountrySuccessInput onSuccess(GraphQLSuccessResponse response) {
    return CountrySuccessInput.fromJson(response.data);
  }
}

class CountryRequest extends QueryGraphQLRequest {
  CountryRequest({required this.continentCode});

  final String continentCode;

  @override
  String get document => r'''
    query ($countriesFilter: CountryFilterInput) {
      countries(filter: $countriesFilter) {
        name
        emoji
        capital
      }
    }
  ''';

  @override
  Map<String, dynamic>? get variables {
    return {
      'countriesFilter': {
        'continent': {'eq': continentCode}
      }
    };
  }
}
