import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key, required this.email});

  final String? email;

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter += 1;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FeatureBuilder<int>(
            flagKey: 'color',
            defaultValue: Colors.blue.value,
            evaluationContext: EvaluationContext({'email': widget.email ?? ''}),
            builder: (context, colorValue) {
              final color = Color(colorValue);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Welcome ',
                      children: [
                        TextSpan(
                          text: widget.email ?? 'anonymous',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const TextSpan(text: ','),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You have pushed the button this many times:',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(onPrimary: color),
                    child: const Text('LOG OUT'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
