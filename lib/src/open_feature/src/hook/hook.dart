import 'dart:async';

import '../evaluation_context/evaluation_context.dart';
import '../flag_evaluation/flag_evaluation_details.dart';
import 'hook_context.dart';
import 'hook_hints.dart';

export 'hook_context.dart';
export 'hook_hints.dart';

abstract class Hook<T extends Object> {
  FutureOr<EvaluationContext?> before({
    required HookContext<T> context,
    HookHints? hints,
  }) async {
    return null;
  }

  FutureOr<void> after({
    required HookContext<T> context,
    required FlagEvaluationDetails<T> details,
    HookHints? hints,
  }) {}

  FutureOr<void> error({
    required HookContext<T> context,
    required Object error,
    HookHints? hints,
  }) {}

  FutureOr<void> finallyAfter({
    required HookContext<T> context,
    HookHints? hints,
  }) {}
}
