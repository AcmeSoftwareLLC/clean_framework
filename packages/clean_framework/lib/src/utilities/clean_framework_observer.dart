import 'dart:developer';

import 'package:clean_framework/src/core/core.dart';
import 'package:meta/meta.dart';

/// The class to observe failures, route changes and other events.
class CleanFrameworkObserver {
  /// Default constructor.
  CleanFrameworkObserver({
    this.enableNetworkLogs = true,
  });

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
  @mustCallSuper
  void onExternalError(
    Object externalInterface,
    Request request,
    Object error,
    StackTrace stackTrace,
  ) {
    log(
      'Error occurred while requesting "${request.runtimeType}" '
      'for "${externalInterface.runtimeType}"',
      name: 'Clean Framework',
      stackTrace: stackTrace,
      error: error,
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
    Output gatewayOutput,
    SuccessInput input,
  ) {}

  /// Called when a failure [input] occurs in an use case.
  void onFailureInput(
    UseCase useCase,
    Output gatewayOutput,
    FailureInput input,
  ) {}

  /// Called when [location] of the route changes.
  void onLocationChanged(String location) {}
}
