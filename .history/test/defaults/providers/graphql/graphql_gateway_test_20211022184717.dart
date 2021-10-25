import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GraphQLGateway', () {
    final gateway = TestGateway(UseCaseFake());
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
