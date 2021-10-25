import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLGateway', () {});
}

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
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: 'test');
  }

  @override
  CountrySuccessInput onSuccess(GraphQLSuccessResponse response) {
    return CountrySuccessInput.fromJson(response.data);
  }
}

class TestRequest extends QueryGraphQLRequest {
  TestRequest();

  @override
  String get document => r'''
   
  ''';

  @override
  Map<String, dynamic>? get variables {
    return {};
  }

  @override
  List<Object?> get props => [];
}
