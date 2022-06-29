//ignore_for_file: INVALID_USE_OF_VISIBLE_FOR_TESTING_MEMBER

import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@visibleForTesting
Type type<T extends Object>() => T;

_UITestConfig? _uiTestConfig;

@visibleForTesting
void setupUITest({
  required ProvidersContext context,
  required AppRouter router,
}) {
  _uiTestConfig = _UITestConfig(
    context: context,
    router: router,
  );
}

class _UITestConfig {
  _UITestConfig({
    required this.context,
    required this.router,
  });

  final ProvidersContext context;
  final AppRouter router;
}

/// Can be used to wrap the test widget with other widgets.
///
/// uiTestWidgetBuilder = (child) {
///   return Internationalization(
///     locale: Locale('ne', 'NP'),
///     child: child,
///   );
/// }
///
@visibleForTesting
Widget Function(Widget child) uiTestWidgetBuilder = (child) => child;

@isTest
void uiTest(
  String description, {
  required WidgetTesterCallback verify,
  ProvidersContext? context,
  UI Function()? builder,
  AppRouter? router,
  FutureOr<void> Function()? setup,
  FutureOr<void> Function(WidgetTester)? postFrame,
  bool wrapWithMaterialApp = true,
  Duration? pumpDuration,
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
  Size? screenSize,
  Iterable<LocalizationsDelegate>? localizationDelegates,
  Widget Function(Widget)? parentBuilder,
}) {
  assert(
    () {
      return localizationDelegates == null || wrapWithMaterialApp;
    }(),
    'Need to wrap with MaterialApp if overriding localization delegates is required',
  );

  final _router = router ?? _uiTestConfig?.router;
  final _context = context ?? _uiTestConfig?.context;

  assert(
    () {
      return builder != null || _router != null;
    }(),
    'Provide either "builder" or "router".',
  );
  assert(
    () {
      return _router == null || wrapWithMaterialApp;
    }(),
    '"router" should not be passed when wrapWithMaterialApp is false',
  );
  assert(
    () {
      return _context != null;
    }(),
    'Either pass "context" or call "setupUITest()" before test block.',
  );

  testWidgets(
    description,
    (tester) async {
      final window = tester.binding.window;
      if (screenSize != null) {
        window.physicalSizeTestValue = screenSize * window.devicePixelRatio;
      }

      await setup?.call();

      Widget _scopedChild(Widget child) {
        return uiTestWidgetBuilder(
          UncontrolledProviderScope(container: _context!(), child: child),
        );
      }

      Widget child;
      if (wrapWithMaterialApp) {
        if (builder == null) {
          _router!.navigatorBuilder = (_, __, nav) => _scopedChild(nav);
          child = MaterialApp.router(
            routeInformationParser: _router.informationParser,
            routerDelegate: _router.delegate,
            routeInformationProvider: _router.informationProvider,
            localizationsDelegates: localizationDelegates,
          );
        } else {
          child = MaterialApp(
            home: _scopedChild(builder()),
            localizationsDelegates: localizationDelegates,
          );
        }
      } else {
        child = _scopedChild(builder!());
      }

      await tester.pumpWidget(
        parentBuilder == null ? child : parentBuilder(child),
        pumpDuration,
      );

      if (postFrame == null) {
        await tester.pumpAndSettle();
      } else {
        await postFrame(tester);
      }

      await verify(tester);

      if (screenSize != null) window.clearPhysicalSizeTestValue();
    },
    skip: skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

@isTest
void useCaseTest<U extends UseCase, O extends Output>(
  String description, {
  required ProvidersContext context,
  required U Function(Ref) build,
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
