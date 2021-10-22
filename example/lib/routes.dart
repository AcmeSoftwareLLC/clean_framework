import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/country/presentation/country_ui.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_ui.dart';
import 'package:clean_framework_example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:clean_framework_example/home_page.dart';
import 'package:flutter/material.dart';

enum Routes {
  home,
  lastLogin,
  countries,
  randomCat,
}

final router = AppRouter<Routes>(
  routes: [
    AppRoute(
      name: Routes.home,
      path: '/',
      builder: (context, state) => HomePage(),
      routes: [
        AppRoute(
          name: Routes.lastLogin,
          path: 'last-login',
          builder: (context, state) => LastLoginUI(),
        ),
        AppRoute(
          name: Routes.countries,
          path: 'countries',
          builder: (context, state) => CountryUI(),
        ),
        AppRoute(
          name: Routes.randomCat,
          path: 'random-cat',
          builder: (context, state) => RandomCatUI(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    );
  },
);
