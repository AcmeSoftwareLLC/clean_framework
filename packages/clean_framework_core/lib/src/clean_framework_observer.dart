abstract class ExternalInterfaceBase {}

abstract class RequestBase {}

abstract class ResponseBase {}

abstract class InputBase {}

/// The class to observe failures, route changes and other events.
class CleanFrameworkObserver {
  /// Enables network logs.
  bool get enableNetworkLogs => true;

  /// Default instance of [CleanFrameworkObserver].
  ///
  /// This can be changed in following way:
  /// ```dart
  /// CleanFrameworkObserver.instance = SubClassOfCleanFrameworkObserver();
  /// ```
  static CleanFrameworkObserver instance = CleanFrameworkObserver();

  /// Called when an [error] is thrown by [ExternalInterface] for the given [request].
  void onExternalError(
    covariant ExternalInterfaceBase externalInterface,
    covariant RequestBase request,
    Object error,
  ) {}

  /// Called when a [failureResponse] occurs for the given [request].
  void onFailureResponse(
    covariant ExternalInterfaceBase externalInterface,
    covariant RequestBase request,
    covariant ResponseBase failureResponse,
  ) {}

  /// Called when a [failure] occurs in a gateway.
  void onFailureInput(covariant InputBase failure) {}

  /// Called when [location] of the route changes.
  void onLocationChanged(String location) {}
}
