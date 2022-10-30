class Deserializer {
  Deserializer(this.map);

  final Map<String, dynamic> map;

  String getString(String key, {String defaultValue = ''}) {
    final value = map[key];

    if (value is String) return value;
    return defaultValue;
  }

  int getInt(String key, {int defaultValue = 0}) {
    final value = map[key];

    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  double getDouble(String key, {double defaultValue = 0}) {
    final value = map[key];

    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  bool getBool(String key, {bool defaultValue = false}) {
    final value = map[key];

    if (value is bool) return value;
    return defaultValue;
  }

  Map<String, dynamic> getMap(
    String key, {
    Map<String, dynamic> defaultValue = const {},
  }) {
    final value = map[key];

    if (value is Map) return value.cast<String, dynamic>();
    return defaultValue;
  }

  List<T> getList<T extends Object>(
    String key, {
    List<T> defaultValue = const [],
    required T Function(Map<String, dynamic>) converter,
  }) {
    final value = map[key];

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
    final value = map[key];

    if (value is List) return List<T>.from(value);
    return defaultValue;
  }

  T getEnum<T extends Enum>(
    String key, {
    required List<T> values,
    required T defaultValue,
    required String Function(T) matcher,
  }) {
    final value = map[key];

    return values.firstWhere(
      (v) => matcher(v) == value,
      orElse: () => defaultValue,
    );
  }

  DateTime getDateTime(String key, {DateTime? defaultValue}) {
    final value = map[key];
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
