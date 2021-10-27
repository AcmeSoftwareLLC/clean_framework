import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  test('GraphQLService success query', () {
    // for coverage purposes
    GraphQLService(link: '');
    final mock = GraphQLClientMock();
    final service = GraphQLService(link: '', client: mock);

    when(() => mock.query(any())).thenAnswer((_) async => QueryResult());
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}
