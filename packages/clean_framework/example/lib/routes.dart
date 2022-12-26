import 'package:clean_framework_router/clean_framework_router.dart';

enum Routes with RoutesMixin {
  home('/'),
  lastLogin('last-login'),
  countries('countries'),
  countryDetail(':country'),
  randomCat('random-cat');

  const Routes(this.path);

  final String path;
}
