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
    super.message,
  });

  final T type;
  final Map<String, Object?> errorData;

  @override
  List<Object?> get props => [...super.props, type, errorData];
}

class UnknownFailureResponse extends FailureResponse {
  UnknownFailureResponse([Object? error]) : super(message: error.toString());
}
