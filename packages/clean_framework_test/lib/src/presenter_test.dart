import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:clean_framework_test/src/ui_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTest
void presenterTest<V extends ViewModel, O extends Output, U extends UseCase>(
  String description, {
  List<Override> overrides = const [],
  required Presenter Function(WidgetBuilder builder) create,
  FutureOr<void> Function(U useCase)? setup,
  Iterable<dynamic> Function()? expect,
  FutureOr<void> Function(WidgetTester tester)? verify,
  Widget Function(BuildContext, Widget)? builder,
}) {
  testWidgets(description, (tester) async {
    final vmController = StreamController<V>();

    final presenter = create(
      (context) {
        vmController.add(ViewModelScope.of<V>(context));
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

    Future<void>? expectation;
    if (expect != null) {
      expectation = expectLater(vmController.stream, emitsInOrder(expect()));
    }

    await verify?.call(tester);
    if (expectation != null) await expectation;
  });
}

@isTest
void presenterCallbackTest<V extends ViewModel, O extends Output,
    U extends UseCase>(
  String description, {
  required U useCase,
  required Presenter Function(WidgetBuilder builder) create,
  required FutureOr<void> Function(U useCase) setup,
  required FutureOr<void> Function(U useCase, V vm) verify,
}) {
  test(description, () async {
    final presenter = create((_) => const SizedBox.shrink());

    await setup(useCase);

    // ignore: invalid_use_of_protected_member
    final vm = presenter.createViewModel(useCase, useCase.getOutput<O>());

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
