import 'package:clean_framework/src/core/core.dart';

sealed class UseCaseInput<S extends SuccessInput> {
  const UseCaseInput([this._success, this._failure]);

  final S? _success;
  final FailureInput? _failure;
}

class Success<S extends SuccessInput> extends UseCaseInput<S> {
  const Success(S input) : super(input, null);

  S get input => super._success!;
}

class Failure<S extends SuccessInput> extends UseCaseInput<S> {
  const Failure(FailureInput input) : super(null, input);

  FailureInput get input => super._failure!;
}
