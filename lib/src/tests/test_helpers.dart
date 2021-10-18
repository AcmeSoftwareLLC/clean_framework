import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

Type type<T extends Object>() => T;

@isTest
void uiTest(
  String description, {
  required ProvidersContext context,
  required UI Function() builder,
  required WidgetTesterCallback verify,
  FutureOr<void> Function()? setup,
  bool wrapWithMaterialApp = true,
  bool? skip,
  Timeout? timeout,
  Duration? initialTimeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) {
  testWidgets(
    description,
    (tester) async {
      await setup?.call();

      final scopedWidget = UncontrolledProviderScope(
        container: context(),
        child: builder(),
      );

      await tester.pumpWidget(
        wrapWithMaterialApp ? MaterialApp(home: scopedWidget) : scopedWidget,
      );
      await verify(tester);
    },
    skip: skip,
    timeout: timeout,
    initialTimeout: initialTimeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}
