import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:either_dart/either.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

  Future<Either<FailureInput, S>> _processRequest(R request) async {
    final either = await transport(request);
    return either.fold(
      (failureResponse) => Left(onFailure(failureResponse)),
      (response) => Right(onSuccess(response)),
    );
  }

  S onSuccess(covariant P response);
  FailureInput onFailure(FailureResponse failureResponse);
  R buildRequest(O output);
}

abstract class DomainGateway<ORIGIN_OUTPUT extends Output,
    DESTINATION_OUTPUT extends Output> {
  late UseCase _subscriberUseCase;
  late UseCase _publisherUseCase;

  DomainGateway(
      {required UseCase subscriberUseCase, required UseCase publisherUseCase})
      : _subscriberUseCase = subscriberUseCase,
        _publisherUseCase = publisherUseCase {
          publisherUseCase.subscribe(
      O,
      (O output) async => _processRequest(buildRequest(output)),
    );
        }
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
abstract class Request extends Equatable {
  const Request();

  @override
  bool get stringify => true;
}

@immutable
abstract class Response extends Equatable {
  const Response();
  @override
  bool get stringify => true;
}

class SuccessResponse extends Response {
  const SuccessResponse();

  @override
  List<Object?> get props => [];
}

class FailureResponse extends Response {
  const FailureResponse();

  @override
  List<Object?> get props => [];
}

class RequestNotRecognizedFailureResponse extends FailureResponse {}
