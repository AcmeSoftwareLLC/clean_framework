import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework_graphql/clean_framework_graphql.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphQLExternalInterface | ', () {
    test('success response', () async {
      final gateway = GatewayFake(UseCaseFake());

      // For coverage purposes
      GraphQLExternalInterface(link: '', gatewayConnections: []);

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake({'foo': 'bar'}),
      );

      final result = await gateway.transport(SuccessfulRequest());
      expect(result.isRight, isTrue);
      expect(result.right, const GraphQLSuccessResponse(data: {'foo': 'bar'}));
    });

    test('failure response', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake({}),
      );

      final result = await gateway.transport(SuccessfulRequest());
      expect(result.isLeft, isTrue);

      expect(
        result.left,
        isA<UnknownFailureResponse>().having(
          (r) => r.message,
          'message',
          'service exception',
        ),
      );
    });

    test('success with mutation', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake({'foo': 'bar'}),
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isRight, isTrue);
      expect(result.right, const GraphQLSuccessResponse(data: {'foo': 'bar'}));
    });

    test('failure with mutation', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake({}),
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isLeft, isTrue);
      expect(
        result.left,
        isA<UnknownFailureResponse>().having(
          (r) => r.message,
          'message',
          'service exception',
        ),
      );
    });

    test('operation exception', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake.exception(
          GraphQLOperationException(errors: []),
        ),
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isLeft, isTrue);
      expect(
        result.left,
        const GraphQLFailureResponse(type: GraphQLFailureType.operation),
      );
    });

    test('network exception', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake.exception(
          GraphQLNetworkException(
            message: 'no internet',
            uri: Uri.parse('https://acmesoftware.com'),
          ),
        ),
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isLeft, isTrue);
      expect(
        result.left,
        const GraphQLFailureResponse(
          type: GraphQLFailureType.network,
          message: 'no internet',
          errorData: {'url': 'https://acmesoftware.com'},
        ),
      );
    });

    test('server exception', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface.withService(
        gatewayConnections: [() => gateway],
        service: GraphQLServiceFake.exception(
          GraphQLServerException(
            originalException: const FormatException(),
            errorData: const {},
          ),
        ),
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isLeft, isTrue);
      expect(
        result.left,
        const GraphQLFailureResponse(
          type: GraphQLFailureType.server,
          message: 'FormatException',
        ),
      );
    });

    test('timeout exception', () async {
      final gateway = GatewayFake(UseCaseFake());

      GraphQLExternalInterface(
        link: 'https://acmesoftware.com',
        gatewayConnections: [() => gateway],
        timeout: Duration.zero,
      );

      final result = await gateway.transport(MutationRequest());
      expect(result.isLeft, isTrue);
      expect(
        result.left,
        const GraphQLFailureResponse(
          type: GraphQLFailureType.timeout,
          message: 'Connection Timeout',
        ),
      );
    });
  });
}

class GraphQLServiceFake extends Fake implements GraphQLService {
  GraphQLServiceFake(this._json)
      : _exception = _json.isEmpty ? 'service exception' : null;

  GraphQLServiceFake.exception(GraphQLServiceException exception)
      : _exception = exception,
        _json = const {};

  final Map<String, dynamic> _json;
  final Object? _exception;

  @override
  Future<GraphQLServiceResponse> request({
    required GraphQLMethod method,
    required String document,
    Map<String, dynamic>? variables,
    Duration? timeout,
    GraphQLFetchPolicy? fetchPolicy,
    GraphQLErrorPolicy? errorPolicy,
  }) async {
    if (_exception != null) throw _exception!;

    return GraphQLServiceResponse(
      data: _json,
      errors: [],
    );
  }
}

class GatewayFake extends GraphQLGateway {
  GatewayFake(UseCase useCase) : super(useCase: useCase);

  @override
  MutationRequest buildRequest(Output output) {
    return MutationRequest();
  }

  @override
  SuccessInput onSuccess(GraphQLSuccessResponse response) {
    return SuccessInput();
  }
}

class MutationGatewayFake extends GraphQLGateway {
  MutationGatewayFake(UseCase useCase) : super(useCase: useCase);

  @override
  SuccessfulRequest buildRequest(Output output) {
    return SuccessfulRequest();
  }

  @override
  SuccessInput onSuccess(GraphQLSuccessResponse response) {
    return SuccessInput();
  }
}

class SuccessfulRequest extends QueryGraphQLRequest {
  @override
  String get document => '''
   
  ''';
}

class MutationRequest extends MutationGraphQLRequest {
  @override
  String get document => '''
   
  ''';
}
