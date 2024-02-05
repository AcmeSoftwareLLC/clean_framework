import 'package:clean_framework_router/clean_framework_router.dart';

enum Routes with RoutesMixin {
  home('/'),
  profile(':pokemon_name'),
  form('form');

  const Routes(this.path);

  @override
  final String path;
}
