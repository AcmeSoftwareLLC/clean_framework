import '../evaluation_context/evaluation_context.dart';
import '../flag_evaluation/flag_evaluation_details.dart';
import '../flag_evaluation/flag_evaluation_options.dart';
import 'enums.dart';

abstract class Features {
  Future<FlagEvaluationDetails<bool>> getBooleanDetails({
    required String key,
    required bool defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  });

  Future<FlagEvaluationDetails<String>> getStringDetails({
    required String key,
    required String defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  });

  Future<FlagEvaluationDetails<num>> getNumberDetails({
    required String key,
    required num defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  });

  Future<FlagEvaluationDetails<T>> getDetails<T extends Object>({
    required String key,
    required T defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  });

  Future<bool> getBooleanValue({
    required String key,
    required bool defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return _evaluatedValue(
      getBooleanDetails(
        key: key,
        defaultValue: defaultValue,
        context: context,
        options: options,
      ),
    );
  }

  Future<String> getStringValue({
    required String key,
    required String defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return _evaluatedValue(
      getStringDetails(
        key: key,
        defaultValue: defaultValue,
        context: context,
        options: options,
      ),
    );
  }

  Future<num> getNumberValue({
    required String key,
    required num defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return _evaluatedValue(
      getNumberDetails(
        key: key,
        defaultValue: defaultValue,
        context: context,
        options: options,
      ),
    );
  }

  Future<T> getValue<T extends Object>({
    required String key,
    required T defaultValue,
    EvaluationContext? context,
    FlagEvaluationOptions? options,
  }) {
    return _evaluatedValue(
      getDetails(
        key: key,
        defaultValue: defaultValue,
        context: context,
        options: options,
      ),
    );
  }

  Future<T> _evaluatedValue<T extends Object>(
    Future<FlagEvaluationDetails<T>> detailsFuture,
  ) async {
    final details = await detailsFuture;

    if (details.reason == Reason.error) throw Exception(details.errorCode);
    return details.value;
  }
}
