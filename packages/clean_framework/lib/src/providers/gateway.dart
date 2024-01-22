import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:meta/meta.dart';

abstract class Gateway<O extends DomainOutput, R extends Request,
    P extends SuccessResponse, S extends SuccessDomainInput> {
  Gateway({
    ProvidersContext? context,
    UseCaseProvider? provider,
    UseCase? useCase,
  }) : assert(
          () {
            return (context != null && provider != null) || useCase != null;
          }(),
          '',
        ) {
    _useCase = useCase ?? provider!.getUseCaseFromContext(context!);
    _useCase.subscribe<O, S>(
      (output) => _processRequest(buildRequest(output)),
    );
  }

  late UseCase _useCase;

  late final Transport<R, P> transport;

  S onSuccess(covariant P response);
  FailureDomainInput onFailure(covariant FailureResponse failureResponse);
  R buildRequest(O output);

  Future<Either<FailureDomainInput, S>> _processRequest(R request) async {
    final either = await transport(request);
    return either.fold(
      (failureResponse) => Either.left(onFailure(failureResponse)),
      (response) => Either.right(onSuccess(response)),
    );
  }
}

abstract class BridgeGateway<
    SUBSCRIBER_OUTPUT extends DomainOutput,
    PUBLISHER_OUTPUT extends DomainOutput,
    SUBSCRIBER_INPUT extends DomainInput> {
  BridgeGateway({
    required UseCase subscriberUseCase,
    required UseCase publisherUseCase,
  })  : _subscriberUseCase = subscriberUseCase,
        _publisherUseCase = publisherUseCase {
    _subscriberUseCase.subscribe<SUBSCRIBER_OUTPUT, SUBSCRIBER_INPUT>(
      (output) {
        return Either<FailureDomainInput, SUBSCRIBER_INPUT>.right(
          onResponse(
            _publisherUseCase.getOutput<PUBLISHER_OUTPUT>(),
          ),
        );
      },
    );
  }
  late final UseCase _subscriberUseCase;
  late final UseCase _publisherUseCase;

  SUBSCRIBER_INPUT onResponse(PUBLISHER_OUTPUT output);
}

abstract class WatcherGateway<
    O extends DomainOutput,
    R extends Request,
    P extends SuccessResponse,
    S extends SuccessDomainInput> extends Gateway<O, R, P, S> {
  WatcherGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }

  @nonVirtual
  void yieldResponse(P response) {
    _useCase.setInput(onSuccess(response));
  }
}

typedef Transport<R extends Request, P extends SuccessResponse>
    = Future<Either<FailureResponse, P>> Function(R request);
