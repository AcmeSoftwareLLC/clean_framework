import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

void main() {
  loadProviders();
  runApp(ExampleApp(providersContext: providersContext));
}

class ExampleApp extends StatelessWidget {
  late final ProvidersContext _providersContext;

  ExampleApp({Key? key, ProvidersContext? context}) : super(key: key) {
    _providersContext = context ?? providersContext;
  }

  @override
  Widget build(BuildContext context) {
    return AppProvidersContainer(
      providersContext: _providersContext,
      onBuild: (context, _) {
        _providersContext().read(featureStatesProvider.featuresMap).load({
          'features': [
            {'name': 'last_login', 'state': 'ACTIVE'},
          ]
        });
      },
      child: CFRouterScope(
        initialRoute: Routes.home,
        routeGenerator: Routes.generate,
        builder: (context) {
          return MaterialApp.router(
            routeInformationParser: CFRouteInformationParser(),
            routerDelegate: CFRouterDelegate(context),
          );
        },
      ),
    );
  }
}
