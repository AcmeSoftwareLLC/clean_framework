import 'package:go_router/go_router.dart';

class AppRoute extends GoRoute {
  AppRoute({
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
