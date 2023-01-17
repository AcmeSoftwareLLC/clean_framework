import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Output extends Equatable {
  const Output();

  @override
  bool get stringify => true;
}
