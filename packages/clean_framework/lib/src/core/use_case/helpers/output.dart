import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class DomainOutput extends Equatable {
  const DomainOutput();

  @override
  bool get stringify => true;
}
