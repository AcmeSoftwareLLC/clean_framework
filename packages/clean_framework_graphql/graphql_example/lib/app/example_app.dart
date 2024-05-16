import 'package:graphql_example/providers.dart';
import 'package:graphql_example/router.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class ExampleApp extends StatelessWidget {
  const ExampleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppProviderScope(
      externalInterfaceProviders: [
        graphQlExternalInterfaceProvider,
      ],
      child: AppRouterScope(
        create: ExampleRouter.new,
        builder: (context) {
          return MaterialApp.router(
            title: 'Clean Framework GraphQL Example',
            routerConfig: context.router.config,
            theme: ThemeData(
              colorSchemeSeed: Colors.lightBlueAccent,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.green,
              useMaterial3: true,
            ),
            themeMode: ThemeMode.light,
          );
        },
      ),
    );
  }
}
