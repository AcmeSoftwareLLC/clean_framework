import 'package:clean_framework/src/core/use_case/helpers/domain_dto.dart';
import 'package:meta/meta.dart';

/// Used for the transfer of data into the domain layer (use case) from external
/// layers, services, etc.
@immutable
abstract class DomainInput extends DomainDTO {}

@Deprecated('Use DomainInput.')
abstract class Input extends DomainInput {}

/// Used for the transfer of data into the domain layer (use case) after some
/// success response.
class SuccessDomainInput implements DomainInput {
  const SuccessDomainInput();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

@Deprecated('Use SuccessDomainInput.')
class SuccessInput extends SuccessDomainInput {
  @Deprecated('Use SuccessDomainInput.')
  const SuccessInput() : super();
}

/// Used for the transfer of data into the domain layer (use case) after some
/// failure response.
class FailureDomainInput implements DomainInput {
  const FailureDomainInput({this.message = ''});

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}

@Deprecated('Use FailureDomainInput.')
class FailureInput extends FailureDomainInput {
  @Deprecated('Use FailureDomainInput.')
  const FailureInput({super.message = ''});
}
