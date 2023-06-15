import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routing.dart';
import 'package:clean_framework_example/widgets/app_scope.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class PokeApp extends StatelessWidget {
  const PokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      child: AppProviderScope(
        externalInterfaceProviders: [
          pokemonExternalInterfaceProvider,
        ],
        child: AppRouterScope(
          create: PokeRouter.new,
          builder: (context) {
            return MaterialApp.router(
              title: 'Clean Framework Example',
              routerConfig: context.router.config,
              theme: ThemeData(
                colorSchemeSeed: Colors.green,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorSchemeSeed: Colors.green,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              themeMode: ThemeMode.dark,
            );
          },
        ),
      ),
    );
  }
}
