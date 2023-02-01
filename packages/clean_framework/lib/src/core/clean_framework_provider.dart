import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CleanFrameworkProvider<P extends ProviderBase<Object>> {
  CleanFrameworkProvider({required P provider}) : _provider = provider;

  final P _provider;

  P call() => _provider;
}
