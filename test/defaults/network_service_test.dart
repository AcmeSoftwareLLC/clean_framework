import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestMethod', () {
    expect(RestMethod.get.value, 'GET');
    expect(RestMethod.post.value, 'POST');
    expect(RestMethod.put.value, 'PUT');
    expect(RestMethod.delete.value, 'DELETE');
    expect(RestMethod.patch.value, 'PATCH');
  });

  test('NetworkService assert', () {
    expect(() => WrongNetworkService(), throwsAssertionError);
  });
}

class WrongNetworkService extends NetworkService {
  WrongNetworkService() : super(baseUrl: '/');
}
