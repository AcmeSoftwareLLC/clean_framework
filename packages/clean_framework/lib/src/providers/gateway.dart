import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:meta/meta.dart';

abstract class Gateway<O extends Output, R extends Request,
    P extends SuccessResponse, S extends SuccessInput> {
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
      (output) => _processRequest(buildRequest(output as O)),
    );
  }

  late UseCase _useCase;

  late final Transport<R, P> transport;

  S onSuccess(covariant P response);
  FailureInput onFailure(covariant FailureResponse failureResponse);
  R buildRequest(O output);

  Future<Either<FailureInput, S>> _processRequest(R request) async {
    final either = await transport(request);
    return either.fold(
      (failureResponse) => Either.left(_onFailure(failureResponse)),
      (response) => Either.right(onSuccess(response)),
    );
  }

  FailureInput _onFailure(FailureResponse failureResponse) {
    final failureInput = onFailure(failureResponse);
    CleanFrameworkObserver.instance.onFailureInput(failureInput);
    return failureInput;
  }
}

abstract class BridgeGateway<SUBSCRIBER_OUTPUT extends Output,
    PUBLISHER_OUTPUT extends Output, SUBSCRIBER_INPUT extends Input> {
  BridgeGateway({
    required UseCase subscriberUseCase,
    required UseCase publisherUseCase,
  })  : _subscriberUseCase = subscriberUseCase,
        _publisherUseCase = publisherUseCase {
    _subscriberUseCase.subscribe<SUBSCRIBER_OUTPUT, SUBSCRIBER_INPUT>(
      (output) {
        return Either<FailureInput, SUBSCRIBER_INPUT>.right(
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
    O extends Output,
    R extends Request,
    P extends SuccessResponse,
    S extends SuccessInput> extends Gateway<O, R, P, S> {
  WatcherGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);

  @override
  FailureInput onFailure(FailureResponse failureResponse) => FailureInput();

  @nonVirtual
  void yieldResponse(P response) {
    _useCase.setInput(onSuccess(response));
  }
}

typedef Transport<R extends Request, P extends SuccessResponse>
    = Future<Either<FailureResponse, P>> Function(R request);
