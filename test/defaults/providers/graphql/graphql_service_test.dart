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
    GraphQLService(endpoint: '');
    GraphQLService(endpoint: '', headers: {'Authorization': 'bar'});

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.query(any())).thenAnswer(
      (_) async => successResult,
    );

    final response = await service.request(
      method: GraphQLMethod.query,
      document: '',
    );

    expect(response, {'foo': 'bar'});
  });

  test('GraphQLService success query with tokenBuilder', () async {
    // for coverage purposes
    GraphQLService(endpoint: '', tokenBuilder: () async => 'test-token');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.query(any())).thenAnswer(
      (_) async => successResult,
    );

    final response = await service.request(
      method: GraphQLMethod.query,
      document: '',
    );
    expect(response, {'foo': 'bar'});
  });

  test('GraphQLService query with network exception', () async {
    // for coverage purposes
    GraphQLService(endpoint: '');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.query(any())).thenAnswer(
      (_) async => exceptionResult(
        OperationException(
          linkException: NetworkException(
            message: 'message',
            uri: Uri.parse('https://acmesoftware.com'),
          ),
        ),
      ),
    );

    expectLater(
      () => service.request(method: GraphQLMethod.query, document: ''),
      throwsA(
        isA<GraphQLNetworkException>().having(
          (e) => e.toString(),
          'string representation',
          'GraphQlNetworkException: message; uri = https://acmesoftware.com',
        ),
      ),
    );
  });

  test('GraphQLService query with server exception', () async {
    // for coverage purposes
    GraphQLService(endpoint: '');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.query(any())).thenAnswer(
      (_) async => exceptionResult(
        OperationException(
          linkException: ServerException(
            parsedResponse: Response(data: {'status': 403}, response: {}),
          ),
        ),
      ),
    );

    expectLater(
      () => service.request(method: GraphQLMethod.query, document: ''),
      throwsA(
        isA<GraphQLServerException>().having(
          (e) => e.toString(),
          'string representation',
          'GraphQLServerException{originalException: null, errorData: {status: 403}}',
        ),
      ),
    );
  });

  test('GraphQLService query with operation exception', () async {
    // for coverage purposes
    GraphQLService(endpoint: '');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.query(any())).thenAnswer(
      (_) async => exceptionResult(
        OperationException(
          graphqlErrors: [GraphQLError(message: 'failure')],
        ),
      ),
    );

    expectLater(
      () => service.request(method: GraphQLMethod.query, document: ''),
      throwsA(
        isA<GraphQLOperationException>().having(
          (e) => e.error,
          'error',
          isA<GraphQLOperationError>().having(
            (e) => e.message,
            'message',
            'failure',
          ),
        ),
      ),
    );
  });

  test('GraphQLService success mutation', () async {
    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer((_) async => successResult);

    final response = await service.request(
      method: GraphQLMethod.mutation,
      document: '',
    );
    expect(response, {'foo': 'bar'});
  });

  test('GraphQLService mutation with network exception', () async {
    // for coverage purposes
    GraphQLService(endpoint: '');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer(
      (_) async => exceptionResult(
        OperationException(
          linkException: NetworkException(uri: Uri()),
        ),
      ),
    );

    expectLater(
      () => service.request(method: GraphQLMethod.mutation, document: ''),
      throwsA(isA<GraphQLNetworkException>()),
    );
  });

  test('GraphQLService mutation with server exception', () async {
    // for coverage purposes
    GraphQLService(endpoint: '');

    final service = GraphQLService(endpoint: '', client: mock);

    when(() => mock.mutate(any())).thenAnswer(
      (_) async => exceptionResult(
        OperationException(
          linkException: ServerException(),
        ),
      ),
    );

    expectLater(
      () => service.request(method: GraphQLMethod.mutation, document: ''),
      throwsA(isA<GraphQLServerException>()),
    );
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}

class QueryOptionsMock extends Mock implements QueryOptions {}

class MutationOptionsMock extends Mock implements MutationOptions {}

final successResult = QueryResult.internal(
  source: QueryResultSource.network,
  data: {'foo': 'bar'},
  parserFn: (data) => data,
);

QueryResult<dynamic> exceptionResult(OperationException exception) {
  return QueryResult.internal(
    source: QueryResultSource.network,
    exception: exception,
    parserFn: (data) => data,
  );
}
