import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final mock = GraphQLClientMock();
  setUpAll(() {
    registerFallbackValue(mock);
    registerFallbackValue(QueryOptionsMock());
    registerFallbackValue(MutationOptionsMock());
  });
  test('GraphQLService success query', () async {
    // for coverage purposes
    GraphQLService(link: '');
    final service = GraphQLService(link: '', client: mock);

    when(() => mock.query(any())).thenAnswer((_) async => successResult);

    final response =
        await service.request(method: GraphQLMethod.query, document: '');
    expect(response, {'foo': 'bar'});
  });

  test('GraphQLService success mutation', () async {
    // for coverage purposes
    GraphQLService(link: '');
    final service = GraphQLService(link: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer((_) async => successResult);

    final response =
        await service.request(method: GraphQLMethod.mutation, document: '');
    expect(response, {'foo': 'bar'});
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}

class QueryOptionsMock extends Mock implements QueryOptions {}

class MutationOptionsMock extends Mock implements MutationOptions {}

final successResult =
    QueryResult(source: QueryResultSource.network, data: {'foo': 'bar'});
