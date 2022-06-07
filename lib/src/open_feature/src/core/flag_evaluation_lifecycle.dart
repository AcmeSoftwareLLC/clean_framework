import '../hook/hook.dart';

abstract class FlagEvaluationLifecycle {
  List<Hook> get hooks;

  void addHooks(List<Hook> hooks);

  void clearHooks();
}
