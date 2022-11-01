import 'package:clean_framework_example/features/country/presentation/country_ui.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_ui.dart';
import 'package:clean_framework_example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:clean_framework_example/home_page.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

enum Routes {
  home,
  lastLogin,
  countries,
  countryDetail,
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
          routes: [
            AppRoute(
              name: Routes.countryDetail,
              path: ':country',
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(state.getParam('country')),
                  ),
                  body: Center(
                    child: Text(state.queryParams['capital'].toString()),
                  ),
                );
              },
            ),
          ],
        ),
        AppRoute(
          name: Routes.randomCat,
          path: 'random-cat',
          builder: (context, state) => RandomCatUI(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Page404(error: state.error),
);

class Page404 extends StatelessWidget {
  const Page404({Key? key, required this.error}) : super(key: key);

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(error.toString()),
      ),
    );
  }
}
