// coverage:ignore-file

import 'dart:collection';

class HookHints<T extends Object> extends UnmodifiableMapBase<String, T> {
  HookHints(this._map);

  final Map<String, T> _map;

  @override
  Iterable<String> get keys => _map.keys;

  @override
  T? operator [](Object? key) => _map[key];
}
