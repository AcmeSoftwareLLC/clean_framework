import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';
import 'package:theme_example/features/home/presentation/theme/home_theme_ui.dart';
import 'package:theme_example/router.dart';

class ThemeExampleApp extends StatelessWidget {
  const ThemeExampleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppProviderScope(
      child: AppRouterScope(
        create: ExampleRouter.new,
        builder: (context) {
          return ExampleThemeModeWrapper(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Clean Framework Theme Example',
                routerConfig: context.router.config,
                theme: ThemeData(
                  colorSchemeSeed: Colors.lightBlueAccent,
                  useMaterial3: true,
                ),
                darkTheme: ThemeData(
                  colorSchemeSeed: Colors.green,
                  useMaterial3: true,
                ),
                themeMode: themeMode,
              );
            },
          );
        },
      ),
    );
  }
}
