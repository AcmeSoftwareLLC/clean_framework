import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLGateway success response', () async {
    final useCase = UseCaseFake();
    final gateway = TestGateway(useCase);
    gateway.transport = (request) async =>
        Right<FailureResponse, GraphQLSuccessResponse>(
            GraphQLSuccessResponse(data: {}));

    await useCase.doFakeRequest(TestOutput());
    expect(useCase.entity, EntityFake(value: 'success'));
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
  String get document => r'''
   
  ''';

  @override
  Map<String, dynamic>? get variables {
    return {};
  }

  @override
  List<Object?> get props => [];
}
