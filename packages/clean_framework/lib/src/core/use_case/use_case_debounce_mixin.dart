import 'dart:async';

import 'package:meta/meta.dart';

mixin UseCaseDebounceMixin {
  final Map<String, Timer> _debounceTimers = {};

  /// Executes the [action] so that it will only be executed
  /// when there is no further repeated actions with same [tag]
  /// in a given frame of [duration].
  ///
  /// If [immediate] is false, then then first action will also be debounced.
  @protected
  void debounce({
    required void Function() action,
    required String tag,
    Duration duration = const Duration(milliseconds: 300),
    bool immediate = true,
  }) {
    final timer = _debounceTimers[tag];

    final timerPending = timer?.isActive ?? false;
    final canExecute = immediate && !timerPending;

    timer?.cancel();
    _debounceTimers[tag] = Timer(
      duration,
      () {
        _debounceTimers.remove(tag);
        if (!immediate) action();
      },
    );

    if (canExecute) action();
  }

  @protected
  void clearDebounce() {
    for (final debounceTimer in _debounceTimers.values) {
      debounceTimer.cancel();
    }
    _debounceTimers.clear();
  }
}
