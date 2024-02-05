import 'package:clean_framework/clean_framework.dart';
import 'package:dio/dio.dart';

final restClientProvider = DependencyProvider(
  (_) => Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2/')),
);
