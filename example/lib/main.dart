import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/asset_feature_provider.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:clean_framework_example/routes.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  loadProviders();

  final featureProvider = AssetFeatureProvider();
  OpenFeature.instance.provider = featureProvider;
  await featureProvider.load('assets/flags.json');

  runApp(ExampleApp());
}

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FeatureScope(
      child: AppProvidersContainer(
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
      ),
    );
  }
}
