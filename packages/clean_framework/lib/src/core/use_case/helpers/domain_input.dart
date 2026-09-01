import 'package:clean_framework/src/core/use_case/helpers/domain_dto.dart';
import 'package:meta/meta.dart';

/// Used for the transfer of data into the domain layer (use case) from external
/// layers, services, etc.
@immutable
abstract class DomainInput extends DomainDTO {}

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
class const FailureDomainInput({final String message = ''})
    implements DomainInput {
  @override
  List<Object?> get props => [message];

  @override
  bool? get stringify => true;
}
