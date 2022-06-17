import 'package:feature_flag/login_page.dart';
import 'package:flutter/material.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap with FeatureScope widget.
    return MaterialApp(
      title: 'Feature Flags Demo',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(),
    );
  }
}
