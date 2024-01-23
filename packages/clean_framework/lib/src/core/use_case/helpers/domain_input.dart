import 'package:meta/meta.dart';

/// Used for the transfer of data into the domain layer (use case) from external
/// layers, services, etc.
@immutable
abstract class DomainInput {}

@Deprecated('Use [DomainInput].')
abstract class Input extends DomainInput {}

class SuccessDomainInput implements DomainInput {
  const SuccessDomainInput();
}

@Deprecated('Use [SuccessDomainInput].')
class SuccessInput extends SuccessDomainInput {
  @Deprecated('Use [SuccessDomainInput].')
  const SuccessInput() : super();
}

class FailureDomainInput implements DomainInput {
  const FailureDomainInput({this.message = ''});

  final String message;
}

@Deprecated('Use [FailureDomainInput].')
class FailureInput extends FailureDomainInput {
  @Deprecated('Use [FailureDomainInput].')
  const FailureInput({this.message = ''}) : super(message: message);

  final String message;
}
