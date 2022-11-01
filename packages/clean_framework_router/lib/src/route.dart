import 'package:go_router/go_router.dart';

@Deprecated('Use Route instead.')
typedef AppRoute = Route;

class Route extends GoRoute {
  Route({
    required this.route,
    super.pageBuilder,
    super.builder,
    super.routes,
    super.redirect,
  }) : super(path: route.path, name: (route as Enum).name);

  final RoutesMixin route;
}

mixin RoutesMixin {
  String get path;
}
