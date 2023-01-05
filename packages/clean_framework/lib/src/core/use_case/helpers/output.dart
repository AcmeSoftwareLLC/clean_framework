import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Output extends Equatable {
  @override
  bool get stringify => true;
}
