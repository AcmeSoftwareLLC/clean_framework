import 'package:feature_flag/home_page.dart';
import 'package:flutter/material.dart';

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Flags Demo',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
