import 'package:clean_framework_example/features/country/presentation/country_ui.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_ui.dart';
import 'package:clean_framework_example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:clean_framework_example/home_page.dart';
import 'package:flutter/material.dart';

///
class Routes {
  static const String home = '/home';

  ///
  static const String lastLogin = '/lastLogin';

  ///
  static const String countries = '/countries';

  static const String randomCat = '/random-cat';

  ///
  static Widget generate(String routeName) {
    switch (routeName) {
      case home:
        return HomePage();
      case lastLogin:
        return LastLoginUI();
      case countries:
        return CountryUI();
      case randomCat:
        return RandomCatUI();
      default:
        return Scaffold(
          body: Center(
            child: Text('404, Page Not Found!'),
          ),
        );
    }
  }
}
