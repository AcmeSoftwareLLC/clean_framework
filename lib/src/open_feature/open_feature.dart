// coverage:ignore-file
library open_feature;

import 'src/core/feature_client.dart';
import 'src/evaluation_context/evaluation_context.dart';
import 'src/hook/hook.dart';
import 'src/open_feature_client.dart';
import 'src/provider/feature_provider.dart';
import 'src/provider/no_op_feature_provider.dart';

export 'src/core/enums.dart';
export 'src/core/feature_client.dart';
export 'src/core/resolution_details.dart';
export 'src/evaluation_context/context_transformation_mixin.dart';
export 'src/evaluation_context/evaluation_context.dart';
export 'src/exceptions/open_feature_exception.dart';
export 'src/flag_evaluation/flag_evaluation_options.dart';
export 'src/hook/hook.dart';
export 'src/provider/feature_provider.dart';

class OpenFeature {
  OpenFeature._({
    this.provider = const NoOpFeatureProvider(),
    EvaluationContext? context,
  }) : context = context ?? EvaluationContext.empty();

  final FeatureProvider provider;
  final List<Hook> _hooks = [];
  final EvaluationContext context;

  static OpenFeature? _instance;

  static OpenFeature get instance {
    return _instance ??= OpenFeature._();
  }

  FeatureClient getClient({
    String? name,
    String? version,
  }) {
    return OpenFeatureClient(
      options: OpenFeatureClientOptions(name: name, version: version),
    );
  }

  void addHooks(List<Hook> hooks) => _hooks.addAll(hooks);

  void clearHooks() => _hooks.clear();

  List<Hook> get hooks => List.unmodifiable(_hooks);

  set provider(FeatureProvider provider) {
    _instance = _instance?._copyWith(provider: provider);
  }

  set context(EvaluationContext context) {
    _instance = _instance?._copyWith(context: context);
  }

  OpenFeature _copyWith({
    FeatureProvider? provider,
    EvaluationContext? context,
  }) {
    return OpenFeature._(
      provider: provider ?? this.provider,
      context: context ?? this.context,
    );
  }
}
