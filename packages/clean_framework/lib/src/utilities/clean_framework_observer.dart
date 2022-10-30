import 'dart:developer';

import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_core/clean_framework_core.dart' as core;

class CleanFrameworkObserver extends core.CleanFrameworkObserver {
  CleanFrameworkObserver({this.enableNetworkLogs = true});

  @override
  final bool enableNetworkLogs;

  @override
  void onExternalError(
    ExternalInterface<Request, SuccessResponse> externalInterface,
    Request request,
    Object error,
  ) {
    log(
      error.toString(),
      name: '${externalInterface.runtimeType}[${request.runtimeType}]',
    );
  }

  static core.CleanFrameworkObserver get instance {
    return core.CleanFrameworkObserver.instance;
  }

  static set instance(core.CleanFrameworkObserver observer) {
    core.CleanFrameworkObserver.instance = observer;
  }
}
