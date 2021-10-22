import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

void main() {
  loadProviders();
  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppProvidersContainer(
      providersContext: providersContext,
      onBuild: (context, _) {
        providersContext().read(featureStatesProvider.featuresMap).load({
          'features': [
            {'name': 'last_login', 'state': 'ACTIVE'},
          ]
        });
      },
      child: MaterialApp.router(
        routeInformationParser: router.informationParser,
        routerDelegate: router.delegate,
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
            },
          ),
        ),
      ),
    );
  }
}
