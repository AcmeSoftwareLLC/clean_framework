import 'package:clean_framework/src/core/use_case/use_case.dart';
import 'package:clean_framework/src/presentation/presenter/presenter.dart';
import 'package:clean_framework/src/presentation/presenter/view_model.dart';
import 'package:clean_framework/src/providers/use_case_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Presenter<V extends ViewModel, M extends DomainModel,
    U extends UseCase> extends ConsumerStatefulWidget {
  const Presenter({
    required UseCaseProvider provider,
    required this.builder,
    super.key,
  }) : _provider = provider;

  final UseCaseProvider _provider;
  final PresenterBuilder<V> builder;

  @override
  ConsumerState<Presenter<V, M, U>> createState() => _PresenterState<V, M, U>();

  @protected
  V createViewModel(U useCase, M output);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [output] updates.
  @protected
  void onOutputUpdate(BuildContext context, M output) {}

  /// Called whenever the presenter configuration changes.
  @protected
  void didUpdatePresenter(
    BuildContext context,
    covariant Presenter<V, M, U> old,
    U useCase,
  ) {}

  /// Called when this presenter is removed from the tree.
  @protected
  void onDestroy(U useCase) {}

  @visibleForTesting
  M subscribe(WidgetRef ref) => _provider.subscribe<M>(ref);
}

class _PresenterState<V extends ViewModel, M extends DomainModel,
    U extends UseCase> extends ConsumerState<Presenter<V, M, U>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onLayoutReady(context, _useCase!);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= widget._provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<V, M, U> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    widget._provider.listen<M>(ref, _onOutputChanged);
    final output = widget.subscribe(ref);
    return widget.builder(widget.createViewModel(_useCase!, output));
  }

  void _onOutputChanged(M? previous, M next) {
    if (previous != next) widget.onOutputUpdate(context, next);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.onDestroy(_useCase!);
    });
    super.dispose();
  }
}
