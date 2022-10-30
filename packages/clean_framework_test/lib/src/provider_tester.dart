import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class ProviderTester<S> {

  ProviderTester();
  final _container = ProviderContainer();

  Future<void> pumpWidget(WidgetTester tester, Widget widget) =>
      tester.pumpWidget(
          UncontrolledProviderScope(container: _container, child: widget),);
}
