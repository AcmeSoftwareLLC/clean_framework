import 'package:clean_framework/clean_framework.dart';
import 'package:feature_flag/asset_feature_provider.dart';
import 'package:feature_flag/login_page.dart';
import 'package:flutter/material.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureScope<AssetFeatureProvider>(
      register: () => AssetFeatureProvider(),
      loader: (featureProvider) => featureProvider.load('assets/flags.json'),
      child: MaterialApp(
        title: 'Feature Flags Demo',
        theme: ThemeData(useMaterial3: true),
        home: const LoginPage(),
      ),
    );
  }
}
