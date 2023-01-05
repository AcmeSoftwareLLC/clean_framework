import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Entity extends Equatable {
  @override
  bool get stringify => true;

  external Entity copyWith();
}
