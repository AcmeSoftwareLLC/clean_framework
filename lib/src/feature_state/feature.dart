import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Feature instances are used to identify groups of components that are part
/// of the same flow, share data and are used to encapsule a common behavior.
/// It is recommended that instances of this class are constant, and keep the
/// instances globally shared to simplify its use.
@immutable
class Feature extends Equatable {
  final String name;
  final String version;

  const Feature({required this.name, String? version})
      : version = version ?? '1.0';

  @override
  List<Object?> get props => [name, version];
}
