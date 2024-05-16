import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:clean_framework_test/src/diff.dart';
import 'package:clean_framework_test/src/ui_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:meta/meta.dart';

@isTest
void presenterTest<V extends ViewModel, M extends DomainModel,
    U extends UseCase>(
  String description, {
  required Presenter Function(WidgetBuilder builder) create,
  List<Override> overrides = const [],
  FutureOr<void> Function(U useCase)? setup,
  dynamic Function()? expect,
  FutureOr<void> Function(ft.WidgetTester tester)? verify,
  Widget Function(BuildContext, Widget)? builder,
}) {
  ft.testWidgets(description, (tester) async {
    final viewModels = <V>[];

    final presenter = create(
      (context) {
        viewModels.add(ViewModelScope.of<V>(context));
        return const SizedBox.shrink();
      },
    );

    await tester.pumpWidget(
      AppProviderScope(
        overrides: overrides,
        child: AppRouterScope(
          create: UITestRouter.new,
          builder: (context) {
            final child = MaterialApp(
              home: Scaffold(
                body: _TestBuilder<U>(
                  onInit: setup,
                  presenter: presenter,
                ),
              ),
            );

            return builder?.call(context, child) ?? child;
          },
        ),
      ),
    );
    await tester.pump();

    ft.TestFailure? failure;
    if (expect != null) {
      final expected = expect();
      try {
        ft.expect(viewModels, ft.wrapMatcher(expected));
      } on ft.TestFailure catch (f) {
        if (expected is! List<V>) {
          failure = f;
        } else {
          final differance = diff(expected: expected, actual: viewModels);
          failure = ft.TestFailure('${f.message}\n$differance');
        }
      }
    }

    await verify?.call(tester);

    if (failure != null) throw failure;
  });
}

@isTest
void presenterCallbackTest<V extends ViewModel, M extends DomainModel,
    U extends UseCase>(
  String description, {
  required U useCase,
  required Presenter Function(WidgetBuilder builder) create,
  required FutureOr<void> Function(U useCase) setup,
  required FutureOr<void> Function(U useCase, V vm) verify,
}) {
  ft.test(description, () async {
    final presenter = create((_) => const SizedBox.shrink());

    await setup(useCase);

    // ignore: invalid_use_of_protected_member
    final vm = presenter.createViewModel(useCase, useCase.getDomainModel<M>());

    await verify(useCase, vm as V);
  });
}

class _TestBuilder<U extends UseCase> extends ConsumerStatefulWidget {
  const _TestBuilder({
    required this.onInit,
    required this.presenter,
  });

  final FutureOr<void> Function(U)? onInit;
  final Presenter presenter;

  @override
  ConsumerState<_TestBuilder<U>> createState() => _TestBuilderState<U>();
}

class _TestBuilderState<U extends UseCase>
    extends ConsumerState<_TestBuilder<U>> {
  @override
  void initState() {
    super.initState();

    if (widget.onInit != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // ignore: invalid_use_of_visible_for_testing_member
        final useCase = widget.presenter.provider.read(
          ProviderScope.containerOf(context),
        );
        widget.onInit!(useCase as U);
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.presenter;
}
