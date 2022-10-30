import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLGateway success response', () async {
    final useCase = UseCaseFake();
    final gateway = TestGateway(useCase)
      ..transport = (request) async {
        return const Right<FailureResponse, GraphQLSuccessResponse>(
          GraphQLSuccessResponse(data: {}),
        );
      };

    await useCase.doFakeRequest(TestOutput());
    expect(useCase.entity, EntityFake(value: 'success'));

    final request = gateway.buildRequest(TestOutput());
    expect(request.variables, null);
  });

  test('GraphQLGateway failure response', () async {
    final useCase = UseCaseFake();
    TestGateway(useCase).transport = (request) async {
      return const Left<FailureResponse, GraphQLSuccessResponse>(
        GraphQLFailureResponse(type: GraphQLFailureType.operation),
      );
    };

    await useCase.doFakeRequest(TestOutput());
    expect(useCase.entity, EntityFake(value: 'failure'));
  });
}

class TestGateway
    extends GraphQLGateway<TestOutput, TestRequest, SuccessInput> {
  TestGateway(UseCase useCase) : super(useCase: useCase);

  @override
  TestRequest buildRequest(TestOutput output) {
    return TestRequest();
  }

  @override
  SuccessInput onSuccess(GraphQLSuccessResponse response) {
    return SuccessInput();
  }
}

class TestOutput extends Output {
  @override
  List<Object?> get props => [];
}

class TestRequest extends QueryGraphQLRequest {
  TestRequest();

  @override
  String get document => '''
   
  ''';
}
