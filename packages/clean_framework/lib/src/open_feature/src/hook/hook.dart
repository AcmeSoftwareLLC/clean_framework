// coverage:ignore-file

import 'dart:async';

import 'package:clean_framework/src/open_feature/src/evaluation_context/evaluation_context.dart';
import 'package:clean_framework/src/open_feature/src/flag_evaluation/flag_evaluation_details.dart';
import 'package:clean_framework/src/open_feature/src/hook/hook_context.dart';
import 'package:clean_framework/src/open_feature/src/hook/hook_hints.dart';

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
