import 'package:example/features/country/presentation/country_ui.dart';
import 'package:example/features/last_login/presentation/last_login_ui.dart';
import 'package:example/features/random_cat/presentation/random_cat_ui.dart';
import 'package:example/home_page.dart';
import 'package:example/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class DemoRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (context, state) => HomePage(),
          routes: [
            AppRoute(
              route: Routes.lastLogin,
              builder: (context, state) => LastLoginUI(),
            ),
            AppRoute(
              route: Routes.countries,
              builder: (context, state) => CountryUI(),
              routes: [
                AppRoute(
                  route: Routes.countryDetail,
                  builder: (context, state) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(state.params['country'] ?? ''),
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
              route: Routes.randomCat,
              builder: (context, state) => RandomCatUI(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Page404(error: state.error),
    );
  }
}

class Page404 extends StatelessWidget {
  const Page404({required this.error});

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
