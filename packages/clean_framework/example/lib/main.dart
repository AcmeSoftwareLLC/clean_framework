import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routing/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderScope(
      externalInterfaceProviders: [
        pokemonExternalInterfaceProvider,
      ],
      child: AppRouterScope(
        create: PokeRouter.new,
        builder: (context) {
          return MaterialApp.router(
            title: 'Clean Framework Example',
            routerConfig: context.router.config,
            theme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              useMaterial3: true,
            ),
            darkTheme: ThemeData.from(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: ThemeMode.dark,
          );
        },
      ),
    );
  }
}
