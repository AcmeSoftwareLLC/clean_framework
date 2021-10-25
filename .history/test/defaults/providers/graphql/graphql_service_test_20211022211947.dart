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

  test('GraphQLService query with exception', () async {
    // for coverage purposes
    GraphQLService(link: '');

    final service = GraphQLService(link: '', client: mock);

    when(() => mock.query(any())).thenAnswer((_) async => exceptionResult);

    expectLater(
        () => service.request(method: GraphQLMethod.query, document: ''),
        throwsA(isA<ExternalGraphQLServiceException>()));
  });

  test('GraphQLService query with no content', () async {
    // for coverage purposes
    GraphQLService(link: '');

    final service = GraphQLService(link: '', client: mock);

    when(() => mock.query(any())).thenAnswer((_) async => emptyResult);

    expectLater(
        () => service.request(method: GraphQLMethod.query, document: ''),
        throwsA(isA<NullDataGraphQLServiceException>()));
  });

  test('GraphQLService success mutation', () async {
    final service = GraphQLService(link: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer((_) async => successResult);

    final response =
        await service.request(method: GraphQLMethod.mutation, document: '');
    expect(response, {'foo': 'bar'});
  });

  test('GraphQLService mutation with exception', () async {
    // for coverage purposes
    GraphQLService(link: '');

    final service = GraphQLService(link: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer((_) async => exceptionResult);

    expectLater(
        () => service.request(method: GraphQLMethod.query, document: ''),
        throwsA(isA<ExternalGraphQLServiceException>()));
  });

  test('GraphQLService mutation with no content', () async {
    // for coverage purposes
    GraphQLService(link: '');

    final service = GraphQLService(link: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer((_) async => emptyResult);

    expectLater(
        () => service.request(method: GraphQLMethod.query, document: ''),
        throwsA(isA<NullDataGraphQLServiceException>()));
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}

class QueryOptionsMock extends Mock implements QueryOptions {}

class MutationOptionsMock extends Mock implements MutationOptions {}

final successResult =
    QueryResult(source: QueryResultSource.network, data: {'foo': 'bar'});

final exceptionResult = QueryResult(
    source: QueryResultSource.network, exception: OperationException());

final emptyResult = QueryResult(source: QueryResultSource.network);
