import 'dart:developer';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/asset_feature_provider.dart';
import 'package:clean_framework_example/demo_router.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadProviders();

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureScope<AssetFeatureProvider>(
      register: () => AssetFeatureProvider(),
      loader: (featureProvider) async {
        // To demonstrate the lazy update triggered by change in feature flags.
        await Future<void>.delayed(Duration(seconds: 2));
        await featureProvider.load('assets/flags.json');
      },
      onLoaded: () {
        log('Feature Flags activated.');
      },
      child: AppProvidersContainer(
        providersContext: providersContext,
        child: AppRouterScope(
          create: () => DemoRouter(),
          builder: (context) {
            return MaterialApp.router(
              routerConfig: context.router.config,
              theme: ThemeData(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
