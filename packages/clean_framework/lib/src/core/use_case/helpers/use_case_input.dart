import 'package:clean_framework/src/core/core.dart';

sealed class UseCaseInput<S extends SuccessDomainInput> {
  const UseCaseInput([this._success, this._failure]);

  final S? _success;
  final FailureDomainInput? _failure;
}

class SuccessUseCaseInput<S extends SuccessDomainInput>
    extends UseCaseInput<S> {
  const SuccessUseCaseInput(S input) : super(input, null);

  S get input => super._success!;
}

class FailureUseCaseInput<S extends SuccessDomainInput>
    extends UseCaseInput<S> {
  const FailureUseCaseInput(FailureDomainInput input) : super(null, input);

  FailureDomainInput get input => super._failure!;
}
