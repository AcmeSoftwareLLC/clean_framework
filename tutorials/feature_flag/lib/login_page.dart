import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FeatureBuilder<bool>(
              flagKey: 'newTitle',
              valueType: FlagValueType.boolean,
              defaultValue: false,
              builder: (context, showNewTitle) {
                return Text(
                  showNewTitle ? 'Feature Flags Demo' : 'Feature Widget',
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
