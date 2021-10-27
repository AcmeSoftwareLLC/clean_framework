part of 'router.dart';

/// A page that creates a material style [PageRoute].
class CFRoutePage<T> extends MaterialPage {
  final _completer = Completer<T>();

  /// Creates a CFRoutePage.
  CFRoutePage({
    required Widget child,
    required String name,
    Object? arguments,
  }) : super(
          child: child,
          name: name,
          arguments: arguments,
          key: ValueKey<String>(name),
        );

  /// The [CFRouteInformation] extracted from the [CFRoutePage].
  CFRouteInformation get information =>
      CFRouteInformation(name: name!, arguments: arguments);

  @override
  String toString() => 'CFRoutePage<$T>(name: $name, args: $arguments)';
}

/// The route information.
class CFRouteInformation {
  /// The name of the route.
  final String name;

  /// The arguments associated with the route.
  final Object? arguments;

  /// Create a route information with the [name] and [arguments].
  CFRouteInformation({required this.name, this.arguments});

  /// Create a route information by parsing the given [location] string.
  factory CFRouteInformation.fromLocation(String? location) {
    if (location == null) return CFRouteInformation(name: '');
    final uri = Uri.parse(location);
    return CFRouteInformation(name: uri.path, arguments: uri.queryParameters);
  }

  /// Returns the [location] resolved for the [CFRouteInformation].
  String get location {
    if (arguments is Map<String, dynamic>) {
      if ((arguments as Map).isEmpty) return name;
      return Uri(
        path: name,
        queryParameters: arguments as Map<String, dynamic>,
      ).toString();
    }
    return name;
  }
}
