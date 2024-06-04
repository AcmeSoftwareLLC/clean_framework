import 'package:clean_framework/src/core/core.dart';
import 'package:clean_framework/src/utilities/logging/logger_utility.dart';
import 'package:clean_framework/src/utilities/logging/logging_utility.dart';
import 'package:logger/logger.dart';

/// The class to observe failures, route changes and other events.
class CleanFrameworkObserver {
  /// Default constructor.
  CleanFrameworkObserver({
    this.enableNetworkLogs = true,
    LoggingUtility? logger,
  }) : logger = logger ??
            LoggerUtility(
              logger: Logger(),
            );

  final LoggingUtility logger;

  /// Enables network logs.
  final bool enableNetworkLogs;

  /// Default instance of [CleanFrameworkObserver].
  ///
  /// This can be changed in following way:
  /// ```dart
  /// CleanFrameworkObserver.instance = SubClassOfCleanFrameworkObserver();
  /// ```
  static CleanFrameworkObserver instance = CleanFrameworkObserver();

  /// Called when an [error] is thrown by [ExternalInterface]
  /// for the given [request].
  void onExternalError(
    Object externalInterface,
    Request request,
    Object error,
    StackTrace stackTrace,
  ) {
    logger.e(
      'Error occurred while requesting "${request.runtimeType}" '
      'for "${externalInterface.runtimeType}"',
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Called when a [failureResponse] occurs for the given [request].
  void onFailureResponse(
    Object externalInterface,
    Request request,
    FailureResponse failureResponse,
  ) {}

  /// Called when a success [input] occurs in an use case.
  void onSuccessInput(
    UseCase useCase,
    DomainModel toGatewayModel,
    SuccessDomainInput input,
  ) {
    logger.d(
      '[${useCase.runtimeType}] $toGatewayModel\n' '[Success] $input',
      stackTrace: StackTrace.empty,
    );
  }

  /// Called when a failure [input] occurs in an use case.
  void onFailureInput(
    UseCase useCase,
    DomainModel toGatewayModel,
    FailureDomainInput input,
  ) {
    logger.d(
      '[${useCase.runtimeType}] $toGatewayModel\n' '[Failure] ${input.message}',
      stackTrace: StackTrace.empty,
    );
  }

  /// Called when [location] of the route changes.
  void onLocationChanged(String location) {}
}
