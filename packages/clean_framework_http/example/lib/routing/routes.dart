import 'package:clean_framework_router/clean_framework_router.dart';

enum Routes with RoutesMixin {
  home('/');

  const Routes(this.path);

  @override
  final String path;
}
