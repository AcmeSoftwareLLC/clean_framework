import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RestMethod', () {
    expect(RestMethod.get.rawString, 'GET');
    expect(RestMethod.post.rawString, 'POST');
    expect(RestMethod.put.rawString, 'PUT');
    expect(RestMethod.delete.rawString, 'DELETE');
    expect(RestMethod.patch.rawString, 'PATCH');
  });

  test('NetworkService assert', () {
    expect(() => WrongNetworkService(), throwsAssertionError);
  });
}

class WrongNetworkService extends NetworkService {
  WrongNetworkService() : super(baseUrl: '/');
}
