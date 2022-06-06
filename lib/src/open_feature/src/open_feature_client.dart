import '../open_feature.dart';
import 'flag_evaluation/flag_evaluation_details.dart';

typedef FeatureProviderResolver<T extends Object> = Future<ResolutionDetails<T>>
    Function({
  required String flagKey,
  required T defaultValue,
  required EvaluationContext context,
  required FlagEvaluationOptions options,
});

class OpenFeatureClientOptions {
  OpenFeatureClientOptions({
    this.name,
    this.version,
  });

  final String? name;
  final String? version;
}

class OpenFeatureClient extends FeatureClient {
  OpenFeatureClient({
    required OpenFeatureClientOptions options,
  })  : name = options.name,
        version = options.version;

  final String? name;
  final String? version;

  final List<Hook> _hooks = [];

  @override
  List<Hook<Object>> get hooks => List.unmodifiable(_hooks);

  @override
  void addHooks(List<Hook<Object>> hooks) {
    _hooks.addAll(hooks);
  }

  @override
  void clearHooks() => _hooks.clear();

  @override
  Future<FlagEvaluationDetails<bool>> getBooleanDetails({
    required String key,
    required bool defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return evaluate(
      flagKey: key,
      flagType: FlagValueType.boolean,
      resolver: _provider.resolveBooleanValue,
      defaultValue: defaultValue,
      context: context,
      options: options,
    );
  }

  @override
  Future<FlagEvaluationDetails<String>> getStringDetails({
    required String key,
    required String defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return evaluate(
      flagKey: key,
      flagType: FlagValueType.string,
      resolver: _provider.resolveStringValue,
      defaultValue: defaultValue,
      context: context,
      options: options,
    );
  }

  @override
  Future<FlagEvaluationDetails<num>> getNumberDetails({
    required String key,
    required num defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return evaluate(
      flagKey: key,
      flagType: FlagValueType.number,
      resolver: _provider.resolveNumberValue,
      defaultValue: defaultValue,
      context: context,
      options: options,
    );
  }

  @override
  Future<FlagEvaluationDetails<T>> getDetails<T extends Object>({
    required String key,
    required T defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return evaluate(
      flagKey: key,
      flagType: FlagValueType.object,
      resolver: _provider.resolveValue,
      defaultValue: defaultValue,
      context: context,
      options: options,
    );
  }

  Future<FlagEvaluationDetails<T>> evaluate<T extends Object>({
    required String flagKey,
    required FlagValueType flagType,
    required FeatureProviderResolver<T> resolver,
    required T defaultValue,
    required EvaluationContext? context,
    required FlagEvaluationOptions? options,
  }) async {
    final mergedHooks = <Hook>[
      ...OpenFeature.instance.hooks,
      ...hooks,
      if (options != null) ...options.hooks,
    ];
    final mergedHooksReversed = mergedHooks.reversed.toList(growable: false);

    final hookContext = HookContext(
      flagKey: flagKey,
      flagType: flagType,
      context: OpenFeature.instance.context.merge(context),
      defaultValue: defaultValue,
      client: this,
      provider: _provider,
    );

    try {
      var mergedContext = await _beforeHooks(
        mergedHooks,
        hookContext,
        options,
      );
      mergedContext = mergedContext.merge(context);

      final provider = _provider;
      final transformedContext = provider is ContextTransformationMixin
          ? await provider.transformContext(mergedContext)
          : mergedContext;

      final resolution = await resolver(
        flagKey: flagKey,
        defaultValue: defaultValue,
        context: transformedContext,
        options: options ?? const FlagEvaluationOptions(),
      );

      final evaluationDetails = FlagEvaluationDetails(
        key: flagKey,
        value: resolution.value,
        reason: resolution.reason,
        errorCode: resolution.errorCode,
        variant: resolution.variant,
      );

      await _afterHooks(
        mergedHooksReversed,
        hookContext,
        evaluationDetails,
        options,
      );

      return evaluationDetails;
    } on OpenFeatureException catch (e) {
      await _errorHooks(mergedHooksReversed, hookContext, e, options);

      return FlagEvaluationDetails(
        key: flagKey,
        value: defaultValue,
        reason: Reason.error,
        errorCode: e.code,
      );
    } finally {
      await _finallyHooks(mergedHooksReversed, hookContext, options);
    }
  }

  Future<EvaluationContext> _beforeHooks(
    List<Hook> hooks,
    HookContext hookContext,
    FlagEvaluationOptions? options,
  ) async {
    var context = hookContext.context;

    for (final hook in hooks) {
      final evalContext = await hook.before(
        context: hookContext,
        hints: options?.hookHints,
      );

      context = context.merge(evalContext);
    }

    return context;
  }

  Future<void> _afterHooks(
    List<Hook> hooks,
    HookContext hookContext,
    FlagEvaluationDetails evaluationDetails,
    FlagEvaluationOptions? options,
  ) async {
    for (final hook in hooks) {
      await hook.after(
        context: hookContext,
        hints: options?.hookHints,
        details: evaluationDetails,
      );
    }
  }

  Future<void> _errorHooks(
    List<Hook> hooks,
    HookContext hookContext,
    Object error,
    FlagEvaluationOptions? options,
  ) async {
    for (final hook in hooks) {
      await hook.error(
        context: hookContext,
        hints: options?.hookHints,
        error: error,
      );
    }
  }

  Future<void> _finallyHooks(
    List<Hook> hooks,
    HookContext hookContext,
    FlagEvaluationOptions? options,
  ) async {
    for (final hook in hooks) {
      await hook.finallyAfter(
        context: hookContext,
        hints: options?.hookHints,
      );
    }
  }

  FeatureProvider get _provider => OpenFeature.instance.provider;
}
