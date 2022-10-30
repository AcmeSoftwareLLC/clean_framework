import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_core/clean_framework_core.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../app_providers_container.dart';

abstract class Gateway<O extends Output, R extends Request,
    P extends SuccessResponse, S extends SuccessInput> {
  late UseCase _useCase;

  late final Transport<R, P> transport;

  Gateway({
    ProvidersContext? context,
    UseCaseProvider? provider,
    UseCase? useCase,
  }) {
    assert(() {
      return (context != null && provider != null) || useCase != null;
    }());
    _useCase = useCase ?? provider!.getUseCaseFromContext(context!);
    _useCase.subscribe(
      O,
      (O output) async => _processRequest(buildRequest(output)),
    );
  }

  S onSuccess(covariant P response);
  FailureInput onFailure(covariant FailureResponse failureResponse);
  R buildRequest(O output);

  Future<Either<FailureInput, S>> _processRequest(R request) async {
    final either = await transport(request);
    return either.fold(
      (failureResponse) => Left(_onFailure(failureResponse)),
      (response) => Right(onSuccess(response)),
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
  late UseCase _subscriberUseCase;
  late UseCase _publisherUseCase;

  BridgeGateway({
    required UseCase subscriberUseCase,
    required UseCase publisherUseCase,
  })  : _subscriberUseCase = subscriberUseCase,
        _publisherUseCase = publisherUseCase {
    _subscriberUseCase.subscribe(
      SUBSCRIBER_OUTPUT,
      (SUBSCRIBER_OUTPUT output) {
        return Right<FailureInput, SUBSCRIBER_INPUT>(
          onResponse(
            _publisherUseCase.getOutput<PUBLISHER_OUTPUT>(),
          ),
        );
      },
    );
  }

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

@immutable
abstract class Request implements RequestBase {
  const Request();
}

@immutable
abstract class Response extends Equatable implements ResponseBase {
  const Response();
  @override
  bool get stringify => true;
}

class SuccessResponse extends Response {
  const SuccessResponse();

  @override
  List<Object?> get props => [];
}

abstract class FailureResponse extends Response {
  const FailureResponse({this.message = ''});

  final String message;

  @override
  List<Object?> get props => [message];
}

class TypedFailureResponse<T extends Object> extends FailureResponse {
  const TypedFailureResponse({
    required this.type,
    this.errorData = const {},
    String message = '',
  }) : super(message: message);

  final T type;
  final Map<String, Object?> errorData;

  @override
  List<Object?> get props => [...super.props, type, errorData];
}

class UnknownFailureResponse extends FailureResponse {
  UnknownFailureResponse([Object? error]) : super(message: error.toString());
}
