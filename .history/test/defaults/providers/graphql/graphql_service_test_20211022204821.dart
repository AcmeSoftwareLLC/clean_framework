import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('GraphQLService success query', () {
    final service = GraphQLService(link: '');
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}
