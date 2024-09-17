import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/providers.dart';
import 'package:clean_framework_http_example/routing.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class CleanFrameworkHttpExampleApp extends StatelessWidget {
  const CleanFrameworkHttpExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderScope(
      externalInterfaceProviders: [pokemonExternalInterfaceProvider],
      child: AppRouterScope(
        create: CleanFrameworkHttpExampleRouter.new,
        builder: (context) {
          return MaterialApp.router(
            title: 'Clean Framework HTTP Example',
            theme: ThemeData(
              colorSchemeSeed: Colors.blue,
              useMaterial3: true,
            ),
            routerConfig: context.router.config,
          );
        },
      ),
    );
  }
}
