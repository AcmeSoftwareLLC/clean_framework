import 'package:clean_framework/clean_framework.dart';
import 'package:meta/meta.dart';

/// Base class for Data Transfer Objects (DTOs) that move data into or out of the domain layer/use case.
@immutable
abstract class DomainDTO extends Equatable {
  const DomainDTO();
}
