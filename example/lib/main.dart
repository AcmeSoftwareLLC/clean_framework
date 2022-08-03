import 'dart:developer';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/asset_feature_provider.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
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
        await Future.delayed(Duration(seconds: 2));
        await featureProvider.load('assets/flags.json');
      },
      onLoaded: () {
        log('Feature Flags activated.');
      },
      child: AppProvidersContainer(
        providersContext: providersContext,
        onBuild: (context, _) {},
        child: MaterialApp.router(
          routeInformationParser: router.informationParser,
          routerDelegate: router.delegate,
          routeInformationProvider: router.informationProvider,
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
