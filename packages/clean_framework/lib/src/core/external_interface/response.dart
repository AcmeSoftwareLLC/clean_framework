import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

abstract class const FailureResponse({final String message = ''})
    extends Response {
  @override
  List<Object?> get props => [message];
}

class const TypedFailureResponse<T extends Object>({
  required final T type,
  final Map<String, Object?> errorData = const {},
  super.message,
}) extends FailureResponse {
  @override
  List<Object?> get props => [...super.props, type, errorData];
}

class UnknownFailureResponse extends FailureResponse {
  UnknownFailureResponse([Object? error]) : super(message: error.toString());
}
