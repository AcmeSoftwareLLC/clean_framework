import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final mock = GraphQLClientMock();

  setUpAll(() {
    registerFallbackValue(mock);
  });
  test('GraphQLService success query', () async {
    // for coverage purposes
    GraphQLService(link: '');
    final service = GraphQLService(link: '', client: mock);

    when(() => mock.query(any())).thenAnswer((_) async => successResult);

    final response =
        await service.request(method: GraphQLMethod.query, document: '');
    expect(response, {'foo', 'bar'});
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}

final successResult =
    QueryResult(source: QueryResultSource.network, data: {'foo': 'bar'});
