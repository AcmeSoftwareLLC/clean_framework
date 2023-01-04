import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/presentation/home_ui.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

final container = ProviderContainer();

void main() {
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  initializeExternalInterfaces(container);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      parent: container,
      child: MaterialApp(
        title: 'Clean Framework Example',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: HomeUI(),
      ),
    );
  }
}
