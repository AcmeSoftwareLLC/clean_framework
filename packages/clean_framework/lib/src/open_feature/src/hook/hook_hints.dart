// coverage:ignore-file

import 'dart:collection';

class HookHints<T extends Object>(final Map<String, T> _map)
    extends UnmodifiableMapBase<String, T> {
  @override
  Iterable<String> get keys => _map.keys;

  @override
  T? operator [](Object? key) => _map[key];
}
