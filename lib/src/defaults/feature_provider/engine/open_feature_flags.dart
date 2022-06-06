import 'dart:convert';

import 'package:clean_framework/src/open_feature/open_feature.dart';

enum FlagState { enabled, disabled }

class OpenFeatureFlags {
  OpenFeatureFlags._(this._flags);

  final Map<String, FeatureFlag> _flags;

  factory OpenFeatureFlags.fromJson(String json) {
    return OpenFeatureFlags.fromMap(jsonDecode(json));
  }

  factory OpenFeatureFlags.fromMap(Map<String, dynamic> map) {
    return OpenFeatureFlags._(
      map.map((k, v) => MapEntry(k, FeatureFlag.fromMap(v))),
    );
  }

  FeatureFlag? operator [](String key) => _flags[key];
}

class FeatureFlag {
  FeatureFlag({
    required this.state,
    this.name,
    this.description,
    this.returnType,
    this.variants = const {},
    this.defaultVariant,
    this.rules = const [],
  });

  final FlagState state;
  final String? name;
  final String? description;
  final FlagValueType? returnType;
  final Map<String, dynamic> variants;
  final String? defaultVariant;
  final List<FlagRule> rules;

  factory FeatureFlag.fromMap(Map<String, dynamic> map) {
    final returnType = map['returnType'];

    return FeatureFlag(
      state: FlagState.values.byName(map['state']),
      name: map['name'],
      description: map['description'],
      returnType:
          returnType == null ? null : FlagValueType.values.byName(returnType),
      variants: map['variants'] ?? {},
      defaultVariant: map['defaultVariant'],
      rules: List.from(map['rules'] ?? [])
          .map((rule) => FlagRule.fromMap(rule))
          .toList(growable: false),
    );
  }
}

class FlagRule {
  FlagRule({
    required this.action,
    required this.conditions,
  });

  final RuleAction action;
  final List<RuleCondition> conditions;

  factory FlagRule.fromMap(Map<String, dynamic> map) {
    return FlagRule(
      action: RuleAction.fromMap(map['action']),
      conditions: List.from(map['conditions'])
          .map((c) => RuleCondition.fromMap(c))
          .toList(growable: false),
    );
  }
}

class RuleAction {
  RuleAction({
    required this.variant,
  });

  final String variant;

  factory RuleAction.fromMap(Map<String, dynamic> map) {
    return RuleAction(
      variant: map['variant'],
    );
  }
}

class RuleCondition {
  RuleCondition({
    required this.context,
    required this.op,
    required this.value,
  });

  final String context;
  final String op;
  final Object value;

  factory RuleCondition.fromMap(Map<String, dynamic> map) {
    return RuleCondition(
      context: map['context'],
      op: map['op'],
      value: map['value'],
    );
  }
}
