import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the domain (or part of the domain) at a particular
/// point in time. Used for the transfer of data from the domain layer to
/// other layers.
@immutable
abstract class DomainModel extends Equatable {
  const DomainModel();

  @override
  bool get stringify => true;
}

@Deprecated('Use DomainModel instead.')
abstract class Output extends DomainModel {
  @Deprecated('Use DomainModel instead.')
  const Output() : super();
}
