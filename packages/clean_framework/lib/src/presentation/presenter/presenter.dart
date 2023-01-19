import 'package:clean_framework/src/core/core.dart';
import 'package:clean_framework/src/presentation/presenter/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Presenter<V extends ViewModel, O extends Output,
    U extends UseCase> extends ConsumerStatefulWidget {
  const Presenter({
    super.key,
    required UseCaseProviderBase provider,
    required this.builder,
  }) : _provider = provider;
  final UseCaseProviderBase _provider;
  final PresenterBuilder<V> builder;

  @override
  ConsumerState<Presenter<V, O, U>> createState() => _PresenterState<V, O, U>();

  @protected
  V createViewModel(U useCase, O output);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [output] updates.
  @protected
  void onOutputUpdate(BuildContext context, O output) {}

  /// Called whenever a new output is received.
  @protected
  @mustCallSuper
  void onOutput(BuildContext context, OutputState<O> output, V viewModel) {
    if (output.hasUpdated) onOutputUpdate(context, output.next);
  }

  /// Called whenever the presenter configuration changes.
  @protected
  void didUpdatePresenter(
    BuildContext context,
    covariant Presenter<V, O, U> old,
    U useCase,
  ) {}

  /// Called when this presenter is removed from the tree.
  @protected
  void onDestroy(U useCase) {}

  @visibleForTesting
  O subscribe(WidgetRef ref) => _provider.subscribe<O>(ref);
}

class _PresenterState<V extends ViewModel, O extends Output, U extends UseCase>
    extends ConsumerState<Presenter<V, O, U>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    widget._provider
      ..notifier.first.then((_) {
        widget.onLayoutReady(context, _useCase!);
      })
      ..init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= widget._provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<V, O, U> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    final output = widget.subscribe(ref);
    final viewModel = widget.createViewModel(_useCase!, output);

    widget._provider.listen<O>(
      ref,
      (p, n) => widget.onOutput(context, OutputState(p, n), viewModel),
    );

    return widget.builder(viewModel);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onDestroy(_useCase!);
    });
    super.dispose();
  }
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);

class OutputState<O extends Output> {
  OutputState(this.previous, this.next);

  final O? previous;
  final O next;

  bool get hasUpdated => previous != next;
}
