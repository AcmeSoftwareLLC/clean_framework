import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'router.dart';

/// A delegate that is used by the [Router] widget to parse a route information.
///
/// ```dart
/// MaterialApp.router(
///   routeInformationParser: CFRouteInformationParser(),
///   routerDelegate: ...,
/// );
/// ```
class CFRouteInformationParser
    extends RouteInformationParser<CFRouteInformation> {
  const CFRouteInformationParser();

  @override
  Future<CFRouteInformation> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    return SynchronousFuture(
      CFRouteInformation.fromLocation(routeInformation.location),
    );
  }

  @override
  RouteInformation restoreRouteInformation(CFRouteInformation configuration) {
    try {
      return RouteInformation(
        location: configuration.location,
        state: configuration.arguments,
      );
    } on JsonUnsupportedObjectError {
      return RouteInformation(location: configuration.location);
    }
  }
}
