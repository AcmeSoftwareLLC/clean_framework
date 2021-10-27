import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {}

class GraphQLServiceFake extends Fake implements GraphQLService {
  final Map<String, dynamic> json;

  GraphQLServiceFake(this.json);

  @override
  Future<Map<String, dynamic>> request(
      {required GraphQLMethod method,
      required String document,
      Map<String, dynamic>? variables}) async {
    if (json.isEmpty) throw 'service exception';
    return json;
  }
}
