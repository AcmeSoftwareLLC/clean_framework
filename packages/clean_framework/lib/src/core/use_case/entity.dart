import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class Entity extends Equatable {
  const Entity();

  @override
  bool get stringify => true;

  Entity copyWith();
}
