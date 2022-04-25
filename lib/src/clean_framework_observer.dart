import 'dart:developer';

import 'package:clean_framework/src/providers/external_interface.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/providers/use_case.dart';

class CleanFrameworkObserver {
  CleanFrameworkObserver({
    this.enableNetworkLogs = true,
  });

  /// Enables network logs.
  final bool enableNetworkLogs;

  static CleanFrameworkObserver instance = CleanFrameworkObserver();

  void onExternalError(
    ExternalInterface externalInterface,
    Request request,
    Object error,
  ) {
    log(
      error.toString(),
      name: '${externalInterface.runtimeType}[${request.runtimeType}]',
    );
  }

  void onFailureResponse(
    ExternalInterface externalInterface,
    Request request,
    FailureResponse failureResponse,
  ) {}

  void onFailureInput(FailureInput failure) {}

  void onLocationChanged(String location) {}
}
