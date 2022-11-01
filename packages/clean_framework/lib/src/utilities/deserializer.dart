class Deserializer {
  Deserializer(Object object)
      : assert(object is Map, '\n\nThe provided object is not a Map.\n'),
        _map = Map.from(object as Map);

  final Map<String, dynamic> _map;

  T map<T extends Object>(T Function(Map<String, dynamic>) converter) {
    return converter(_map);
  }

  String getString(String key, {String defaultValue = ''}) {
    final value = _map[key];

    if (value is String) return value;
    return defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    final value = _map[key];

    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0}) {
    final value = _map[key];

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = _map[key];

    if (value is bool) return value;
    return defaultValue;
  }

  Map<String, dynamic> getMap(
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    final value = _map[key];

    if (value is Map) return value.cast<String, dynamic>();
    return defaultValue;
  }

  List<T> getList<T extends Object>(
    String key, {
    List<T> defaultValue = const [],
    required T Function(Map<String, dynamic>) converter,
  }) {
    final value = _map[key];

    if (value is List) {
      return List<T>.from(
        value.map((v) => converter(v as Map<String, dynamic>)),
      );
    }
    return defaultValue;
  }

  List<T> getSimpleList<T extends Object>(
    String key, {
    List<T> defaultValue = const [],
  }) {
    final value = _map[key];

    if (value is List) return List<T>.from(value);
    return defaultValue;
  }

  T getEnum<T extends Enum>(
    String key, {
    required List<T> values,
    required T defaultValue,
    required String Function(T) matcher,
  }) {
    final value = _map[key];

    return values.firstWhere(
      (v) => matcher(v) == value,
      orElse: () => defaultValue,
    );
  }

  DateTime getDateTime(String key, {DateTime? defaultValue}) {
    final value = _map[key];
    final resolvedDefaultValue = defaultValue ?? DateTime.now();

    if (value is String) {
      return DateTime.tryParse(value) ?? resolvedDefaultValue;
    }

    return resolvedDefaultValue;
  }

  Deserializer call(String key) {
    final value = getMap(key);

    return Deserializer(value);
  }
}

extension DeserializerExtension on Map<String, dynamic> {
  Deserializer get deserialize => Deserializer(this);
}
