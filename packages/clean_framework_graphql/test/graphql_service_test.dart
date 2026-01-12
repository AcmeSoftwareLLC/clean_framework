import 'package:clean_framework_graphql/clean_framework_graphql.dart';
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

  group('GraphQLService tests |', () {
    test('success query', () async {
      // for coverage purposes
      GraphQLService(endpoint: '');
      GraphQLService(endpoint: '', headers: {'Authorization': 'bar'});

      final service = GraphQLService.withClient(client: mock);

      when(() => mock.query(any())).thenAnswer(
        (_) async => successResult,
      );

      final response = await service.request(
        method: GraphQLMethod.query,
        document: '',
        fetchPolicy: GraphQLFetchPolicy.cacheFirst,
      );

      expect(response.data, {'foo': 'bar'});
    });

    test('success query with tokenBuilder', () async {
      // for coverage purposes
      GraphQLService(
        endpoint: '',
        token: GraphQLToken(builder: () => 'Bearer Token'),
      );

      final service = GraphQLService.withClient(client: mock);

      when(() => mock.query(any())).thenAnswer(
        (_) async => successResult,
      );

      final response = await service.request(
        method: GraphQLMethod.query,
        document: '',
      );
      expect(response.data, {'foo': 'bar'});
    });

    test('query with network exception', () async {
      final service = GraphQLService.withClient(client: mock);

      when(() => mock.query(any())).thenAnswer(
        (_) async => exceptionResult(
          OperationException(
            linkException: NetworkException.fromException(
              message: 'message',
              uri: Uri.parse('https://acmesoftware.com'),
              originalException: Object(),
              originalStackTrace: StackTrace.empty,
            ),
          ),
        ),
      );

      await expectLater(
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

    test('query with server exception', () async {
      final service = GraphQLService.withClient(client: mock);

      when(() => mock.query(any())).thenAnswer(
        (_) async => exceptionResult(
          OperationException(
            linkException: const ServerException(
              parsedResponse: Response(data: {'status': 403}, response: {}),
            ),
          ),
        ),
      );

      await expectLater(
        () => service.request(method: GraphQLMethod.query, document: ''),
        throwsA(
          isA<GraphQLServerException>().having(
            (e) => e.toString(),
            'string representation',
            'GraphQLServerException{originalException: null, '
                'errorData: {status: 403}}',
          ),
        ),
      );
    });

    test('query with operation exception', () async {
      final service = GraphQLService.withClient(client: mock);

      when(() => mock.query(any())).thenAnswer(
        (_) async => exceptionResult(
          OperationException(
            graphqlErrors: [const GraphQLError(message: 'failure')],
          ),
        ),
      );

      await expectLater(
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

    test('success mutation', () async {
      final service = GraphQLService.withClient(client: mock);

      when(() => mock.mutate(any())).thenAnswer((_) async => successResult);

      final response = await service.request(
        method: GraphQLMethod.mutation,
        document: '',
      );
      expect(response.data, {'foo': 'bar'});
    });

    test('mutation with network exception', () async {
      // for coverage purposes
      GraphQLService(endpoint: '');

      final service = GraphQLService.withClient(client: mock);

      when(() => mock.mutate(any())).thenAnswer(
        (_) async => exceptionResult(
          OperationException(
            linkException: NetworkException.fromException(
              uri: Uri(),
              originalException: Object(),
              originalStackTrace: StackTrace.empty,
            ),
          ),
        ),
      );

      await expectLater(
        () => service.request(method: GraphQLMethod.mutation, document: ''),
        throwsA(isA<GraphQLNetworkException>()),
      );
    });

    test('mutation with server exception', () async {
      // for coverage purposes
      GraphQLService(endpoint: '');

      final service = GraphQLService.withClient(client: mock);

      when(() => mock.mutate(any())).thenAnswer(
        (_) async => exceptionResult(
          OperationException(
            linkException: const ServerException(),
          ),
        ),
      );

      await expectLater(
        () => service.request(method: GraphQLMethod.mutation, document: ''),
        throwsA(isA<GraphQLServerException>()),
      );
    });

    test('request with error policy', () async {
      final service = GraphQLService.withClient(client: mock);

      when(
        () => mock.query(any()),
      ).thenAnswer((_) async => successResult);

      final response = await service.request(
        method: GraphQLMethod.query,
        document: '',
        errorPolicy: GraphQLErrorPolicy.all,
      );

      expect(response.data, {'foo': 'bar'});

      verify(
        () => mock.query(
          any(
            that: isA<QueryOptions>().having(
              (options) => options.errorPolicy,
              'error policy',
              ErrorPolicy.all,
            ),
          ),
        ),
      );
    });

    test('timeout exception', () async {
      final service = GraphQLService.withClient(client: mock);

      when(
        () => mock.query(any()),
      ).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
        return successResult;
      });

      expect(
        () => service.request(
          method: GraphQLMethod.query,
          document: '',
          errorPolicy: GraphQLErrorPolicy.all,
          timeout: const Duration(milliseconds: 1),
        ),
        throwsA(isA<GraphQLTimeoutException>()),
      );
    });

    test(
      'request without stitched query sets error policy to none by default',
      () async {
        final service = GraphQLService.withClient(client: mock);

        when(
          () => mock.query(any()),
        ).thenAnswer((_) async => successResult);

        const document = '''
query test {
 foo {
  	id
 }
}
''';

        final response = await service.request(
          method: GraphQLMethod.query,
          document: document,
        );

        expect(response.data, {'foo': 'bar'});

        verify(
          () => mock.query(
            any(
              that: isA<QueryOptions>().having(
                (options) => options.errorPolicy,
                'error policy',
                ErrorPolicy.none,
              ),
            ),
          ),
        );
      },
    );

    test(
      'request with stitched query sets error policy to all by default',
      () async {
        final service = GraphQLService.withClient(client: mock);

        when(
          () => mock.query(any()),
        ).thenAnswer((_) async => successResult);

        const document = '''
query test {
 foo {
  	id
 }
 
 bar {
 	id
 }
}
''';

        final response = await service.request(
          method: GraphQLMethod.query,
          document: document,
        );

        expect(response.data, {'foo': 'bar'});

        verify(
          () => mock.query(
            any(
              that: isA<QueryOptions>().having(
                (options) => options.errorPolicy,
                'error policy',
                ErrorPolicy.all,
              ),
            ),
          ),
        );
      },
    );

    test(
      'request with stitched query do not throw operation exception',
      () async {
        final service = GraphQLService.withClient(client: mock);

        when(
          () => mock.query(any()),
        ).thenAnswer(
          (_) async => exceptionResult(
            data: {'foo': 'bar'},
            OperationException(
              graphqlErrors: [
                const GraphQLError(message: 'something went wrong'),
              ],
            ),
          ),
        );

        const document = '''
query test {
 foo {
  	id
 }
 
 bar {
 	id
 }
}
''';

        final response = await service.request(
          method: GraphQLMethod.query,
          document: document,
        );

        expect(response.data, {'foo': 'bar'});
        expect(response.errors.first.message, 'something went wrong');
      },
    );
  });
}

class GraphQLClientMock extends Mock implements GraphQLClient {}

class QueryOptionsMock extends Mock implements QueryOptions {}

class MutationOptionsMock extends Mock implements MutationOptions {}

final QueryResult<Map<String, dynamic>> successResult = QueryResult.internal(
  source: QueryResultSource.network,
  data: {'foo': 'bar'},
  parserFn: (data) => data,
);

QueryResult<dynamic> exceptionResult(
  OperationException exception, {
  Map<String, dynamic>? data,
}) {
  return QueryResult.internal(
    data: data,
    source: QueryResultSource.network,
    exception: exception,
    parserFn: (data) => data,
  );
}
