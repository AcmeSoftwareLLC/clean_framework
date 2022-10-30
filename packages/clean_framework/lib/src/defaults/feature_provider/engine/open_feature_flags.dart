import 'package:clean_framework/clean_framework.dart';

enum FlagState { enabled, disabled }

class OpenFeatureFlags {
  factory OpenFeatureFlags.fromMap(Map<String, dynamic> map) {
    return OpenFeatureFlags._(
      map.map(
        (k, v) => MapEntry(k, FeatureFlag.fromMap(v as Map<String, dynamic>)),
      ),
    );
  }

  OpenFeatureFlags._(this._flags);

  final Map<String, FeatureFlag> _flags;

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

  factory FeatureFlag.fromMap(Map<String, dynamic> map) {
    final flagOptions = Deserializer(map);
    final returnType = map['returnType']?.toString();

    return FeatureFlag(
      state: FlagState.values.byName(map['state'].toString()),
      name: map['name']?.toString(),
      description: map['description']?.toString(),
      returnType:
          returnType == null ? null : FlagValueType.values.byName(returnType),
      variants: flagOptions.getMap('variants'),
      defaultVariant: map['defaultVariant']?.toString(),
      rules: flagOptions.getList('rules', converter: FlagRule.fromMap),
    );
  }

  final FlagState state;
  final String? name;
  final String? description;
  final FlagValueType? returnType;
  final Map<String, dynamic> variants;
  final String? defaultVariant;
  final List<FlagRule> rules;
}

class FlagRule {
  FlagRule({
    required this.action,
    required this.conditions,
  });
  factory FlagRule.fromMap(Map<String, dynamic> map) {
    final data = Deserializer(map);

    return FlagRule(
      action: RuleAction.fromMap(data.getMap('action')),
      conditions: data.getList('conditions', converter: RuleCondition.fromMap),
    );
  }

  final RuleAction action;
  final List<RuleCondition> conditions;
}

class RuleAction {
  RuleAction({
    required this.variant,
  });
  factory RuleAction.fromMap(Map<String, dynamic> map) {
    return RuleAction(
      variant: Deserializer(map).getString('variant'),
    );
  }

  final String variant;
}

class RuleCondition {
  RuleCondition({
    required this.context,
    required this.op,
    required this.value,
  });
  factory RuleCondition.fromMap(Map<String, dynamic> map) {
    final data = Deserializer(map);

    return RuleCondition(
      context: data.getString('context'),
      op: data.getString('op'),
      value: map['value'] as Object,
    );
  }

  final String context;
  final String op;
  final Object value;
}
