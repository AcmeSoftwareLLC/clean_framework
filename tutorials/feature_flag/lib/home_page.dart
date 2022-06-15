import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flags Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FeatureBuilder<int>(
          flagKey: 'color',
          defaultValue: Colors.blue.value,
          evaluationContext: EvaluationContext({'email': email ?? ''}),
          builder: (context, colorValue) {
            final color = Color(colorValue);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: FlutterLogo(
                    size: 64,
                    style: FlutterLogoStyle.horizontal,
                    textColor: color,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Welcome ',
                    children: [
                      TextSpan(
                        text: email ?? 'Anonymous',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(onPrimary: color),
                  child: const Text('LOG OUT'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
