import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UseCaseState extends Equatable {
  const UseCaseState();

  @override
  bool get stringify => true;

  @useResult
  UseCaseState copyWith() =>
      throw UnimplementedError('copyWith() not implemented');
}

@Deprecated('Use [UseCaseState]')
abstract class Entity extends UseCaseState {
  @Deprecated('Use [UseCaseState]')
  const Entity() : super();
}
