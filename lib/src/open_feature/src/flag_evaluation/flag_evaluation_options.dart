import '../hook/hook.dart';

class FlagEvaluationOptions {
  const FlagEvaluationOptions({
    this.hooks = const [],
    this.hookHints,
  });

  final List<Hook> hooks;
  final HookHints? hookHints;
}
