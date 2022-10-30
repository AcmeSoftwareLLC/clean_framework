import 'package:clean_framework/src/open_feature/src/hook/hook.dart';

class FlagEvaluationOptions {
  const FlagEvaluationOptions({
    this.hooks = const [],
    this.hookHints,
  });

  final List<Hook> hooks;
  final HookHints? hookHints;
}
