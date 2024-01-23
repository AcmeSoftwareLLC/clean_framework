import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class Entity extends Equatable {
  const Entity();

  @override
  bool get stringify => true;

  @useResult
  Entity copyWith() => throw UnimplementedError('copyWith() not implemented');
}
