import 'package:clean_framework_http_example/app/clean_framework_http_example_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('BASE_URL', 'https://pokeapi.co/api/v2');

  runApp(const CleanFrameworkHttpExampleApp());
}
