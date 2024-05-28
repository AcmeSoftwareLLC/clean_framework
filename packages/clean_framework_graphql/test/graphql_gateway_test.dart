import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLGateway success response', () async {
    final useCase = UseCaseFake();
    final gateway = TestGateway(useCase)
      ..transport = (request) async {
        return const Either<FailureResponse, GraphQLSuccessResponse>.right(
          GraphQLSuccessResponse(data: {}),
        );
      };

    await useCase.doFakeRequest(TestDomainModel());
    expect(useCase.entity, const EntityFake(value: 'success'));

    final request = gateway.buildRequest(TestDomainModel());
    expect(request.variables, null);
  });

  test('GraphQLGateway failure response', () async {
    final useCase = UseCaseFake();
    TestGateway(useCase).transport = (request) async {
      return const Either.left(
        GraphQLFailureResponse(type: GraphQLFailureType.operation),
      );
    };

    await useCase.doFakeRequest(TestDomainModel());
    expect(useCase.entity, const EntityFake(value: 'failure'));
  });
}

class TestGateway
    extends GraphQLGateway<TestDomainModel, TestRequest, SuccessDomainInput> {
  TestGateway(UseCase useCase) : super(useCase: useCase);

  @override
  TestRequest buildRequest(TestDomainModel output) {
    return TestRequest();
  }

  @override
  SuccessDomainInput onSuccess(GraphQLSuccessResponse response) {
    return const SuccessDomainInput();
  }
}

class TestDomainModel extends DomainModel {
  @override
  List<Object?> get props => [];
}

class TestRequest extends QueryGraphQLRequest {
  TestRequest();

  @override
  String get document => '''
   
  ''';
}
