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
  Size? screenSize,
  Iterable<LocalizationsDelegate>? localizationDelegates,
}) {
  assert((){
    return localizationDelegates == null || wrapWithMaterialApp;,
    
  }(), 'Need to wrap with MaterialApp if overriding localization delegates is required',);

  testWidgets(
    description,
    (tester) async {
      final window = tester.binding.window;
      if (screenSize != null) {
        window.physicalSizeTestValue = screenSize * window.devicePixelRatio;
      }

      await setup?.call();

      final scopedWidget = UncontrolledProviderScope(
        container: context(),
        child: builder(),
      );

      await tester.pumpWidget(
        wrapWithMaterialApp
            ? MaterialApp(
                home: scopedWidget,
                localizationsDelegates: localizationDelegates,
              )
            : scopedWidget,
      );
      await tester.pumpAndSettle();
      await verify(tester);

      if (screenSize != null) window.clearPhysicalSizeTestValue();
    },
    skip: skip,
    timeout: timeout,
    initialTimeout: initialTimeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

@isTest
void useCaseTest<U extends UseCase, O extends Output>(
  String description, {
  required ProvidersContext context,
  required U Function(ProviderRefBase) build,
  required FutureOr<void> Function(U) execute,
  FutureOr<void> Function(UseCaseProvider)? setup,
  Iterable Function()? expect,
  FutureOr<void> Function(U)? verify,
}) {
  test(
    description,
    () async {
      final provider = UseCaseProvider(build);
      await setup?.call(provider);

      final useCase = provider.getUseCaseFromContext(context);

      Future<void>? expectation;
      if (expect != null) {
        expectation = expectLater(
          useCase.stream.map((_) => useCase.getOutput<O>()),
          emitsInOrder(expect()),
        );
      }

      await execute(useCase);
      await expectation;

      await verify?.call(useCase);
    },
  );
}
