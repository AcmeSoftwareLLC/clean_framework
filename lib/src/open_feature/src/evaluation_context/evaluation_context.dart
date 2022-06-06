import 'dart:collection';

class EvaluationContext extends MapMixin<String, Object> {
  EvaluationContext(
    Map<String, Object> map, {
    this.targetingKey,
  }) : _map = map;

  factory EvaluationContext.empty({String? targetingKey}) {
    return EvaluationContext(targetingKey: targetingKey, {});
  }

  final String? targetingKey;
  final Map<String, Object> _map;

  @override
  Object? operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, Object value) {
    _map[key] = value;
  }

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  Object? remove(Object? key) => _map.remove(key);

  EvaluationContext merge(EvaluationContext? other) {
    if (other == null) return this;

    return EvaluationContext(
      targetingKey: targetingKey ?? other.targetingKey,
      {..._map, ...other._map},
    );
  }
}
