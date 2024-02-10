import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_firestore/clean_framework_firestore.dart';
import 'package:clean_framework_test/clean_framework_test_legacy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('FirebaseGateway transport success', () async {
    final useCase = UseCaseFake();
    TestGateway().feedResponse(
      (request) async {
        return const Either.right(
          FirebaseSuccessResponse({'content': 'success'}),
        );
      },
    );

    await useCase.doFakeRequest(const TestDomainModel('123'));

    expect(useCase.entity, const EntityFake(value: 'success'));
  });

  test('FirebaseGateway transport failure', () async {
    final useCase = UseCaseFake();
    TestGateway().feedResponse(
      (request) async {
        return const Either.left(
          FirebaseFailureResponse(type: FirebaseFailureType.noContent),
        );
      },
    );

    await useCase.doFakeRequest(const TestDomainModel('123'));

    expect(useCase.entity, const EntityFake(value: 'failure'));
  });
}

class TestGateway extends FirebaseGateway<TestDomainModel,
    FirebaseReadIdRequest, TestSuccessInput> {
  @override
  FirebaseReadIdRequest buildRequest(TestDomainModel output) =>
      FirebaseReadIdRequest(
        path: 'fake path',
        id: output.id,
      );

  @override
  TestSuccessInput onSuccess(FirebaseSuccessResponse response) {
    final data = Deserializer(response.json);

    return TestSuccessInput(data.getString('content'));
  }
}

class TestDomainModel extends DomainModel {
  const TestDomainModel(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class TestSuccessInput extends SuccessDomainInput {
  const TestSuccessInput(this.foo);

  final String foo;
}
