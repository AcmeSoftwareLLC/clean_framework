import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:meta/meta.dart';

abstract class Gateway<M extends DomainModel, R extends Request,
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
    _useCase.subscribe<M, S>(
      (domainModel) => _processRequest(buildRequest(domainModel)),
    );
  }

  late UseCase _useCase;

  late final Transport<R, P> transport;

  S onSuccess(covariant P response);
  FailureDomainInput onFailure(covariant FailureResponse failureResponse);
  R buildRequest(M output);

  Future<Either<FailureDomainInput, S>> _processRequest(R request) async {
    final either = await transport(request);
    return either.fold(
      (failureResponse) => Either.left(onFailure(failureResponse)),
      (response) => Either.right(onSuccess(response)),
    );
  }
}

abstract class BridgeGateway<SUBSCRIBER_MODEL extends DomainModel,
    PUBLISHER_MODEL extends DomainModel, SUBSCRIBER_INPUT extends DomainInput> {
  BridgeGateway({
    required UseCase subscriberUseCase,
    required UseCase publisherUseCase,
  })  : _subscriberUseCase = subscriberUseCase,
        _publisherUseCase = publisherUseCase {
    _subscriberUseCase.subscribe<SUBSCRIBER_MODEL, SUBSCRIBER_INPUT>(
      (output) {
        return Either<FailureDomainInput, SUBSCRIBER_INPUT>.right(
          onResponse(
            _publisherUseCase.getOutput<PUBLISHER_MODEL>(),
          ),
        );
      },
    );
  }
  late final UseCase _subscriberUseCase;
  late final UseCase _publisherUseCase;

  SUBSCRIBER_INPUT onResponse(PUBLISHER_MODEL output);
}

abstract class WatcherGateway<
    M extends DomainModel,
    R extends Request,
    P extends SuccessResponse,
    S extends SuccessDomainInput> extends Gateway<M, R, P, S> {
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
