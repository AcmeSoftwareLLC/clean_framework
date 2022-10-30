import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework_tests.dart';
import 'package:clean_framework_rest/clean_framework_rest.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestGateway success response', () async {
    final useCase = UseCaseFake();
    final gateway = TestGateway(useCase);
    gateway.transport = (request) async =>
        Right<FailureResponse, RestSuccessResponse>(
            RestSuccessResponse(data: {}));

    await useCase.doFakeRequest(TestOutput());
    expect(useCase.entity, EntityFake(value: 'success'));

    final request = gateway.buildRequest(TestOutput());
    expect(request.params, request.data);
    expect(request.params, isEmpty);
  });

  test('RestGateway failure response', () async {
    final useCase = UseCaseFake();
    final gateway = TestGateway(useCase);
    gateway.transport = (request) async {
      return Left<FailureResponse, RestSuccessResponse>(
        UnknownFailureResponse(),
      );
    };

    await useCase.doFakeRequest(TestOutput());
    expect(useCase.entity, EntityFake(value: 'failure'));
  });

  test('other requests', () {
    final request = TestPostRequest();
    expect(request, isNotNull);
    expect(request.data, isEmpty);
    expect(TestPutRequest(), isNotNull);
    expect(TestPatchRequest(), isNotNull);
    expect(TestDeleteRequest(), isNotNull);
  });
}

class TestGateway extends RestGateway<TestOutput, TestRequest, SuccessInput> {
  TestGateway(UseCase useCase) : super(useCase: useCase);

  @override
  TestRequest buildRequest(TestOutput output) {
    return TestRequest();
  }

  @override
  SuccessInput onSuccess(RestSuccessResponse response) {
    return SuccessInput();
  }
}

class TestOutput extends Output {
  @override
  List<Object?> get props => [];
}

class TestRequest extends GetRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestPostRequest extends PostRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestPutRequest extends PutRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestPatchRequest extends PatchRestRequest {
  @override
  String get path => 'http://fake.com';
}

class TestDeleteRequest extends DeleteRestRequest {
  @override
  String get path => 'http://fake.com';
}
