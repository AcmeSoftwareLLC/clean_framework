import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents the state of the domain at a particular point in time.
@immutable
abstract class DomainModel extends Equatable {
  const DomainModel();

  @override
  bool get stringify => true;
}

@Deprecated('Use [DomainModel].')
abstract class Output extends DomainModel {
  @Deprecated('Use [DomainModel].')
  const Output() : super();
}
