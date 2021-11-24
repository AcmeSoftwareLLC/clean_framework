import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class Presenter<V extends ViewModel, O extends Output,
    U extends UseCase> extends ConsumerStatefulWidget {
  final UseCaseProvider _provider;
  final PresenterBuilder<V> builder;

  Presenter({required UseCaseProvider provider, required this.builder})
      : _provider = provider;

  @override
  _PresenterState<V, O, U> createState() => _PresenterState<V, O, U>();

  V createViewModel(U useCase, O output);

  void onOutputUpdate(BuildContext context, O output) {}

  void onLayoutReady(BuildContext context, U useCase) {}

  @visibleForTesting
  O subscribe(WidgetRef ref) => _provider.subscribe<O>(ref);
}

class _PresenterState<V extends ViewModel, O extends Output, U extends UseCase>
    extends ConsumerState<Presenter<V, O, U>> {
  U? _useCase;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_useCase == null) {
      _useCase = widget._provider.getUseCase(ref) as U;
      widget.onLayoutReady(context, _useCase!);
      widget._provider.listen<O>(ref, _onOutputChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    final output = widget.subscribe(ref);
    return widget.builder(widget.createViewModel(_useCase!, output));
  }

  void _onOutputChanged(O? previous, O next) {
    if (previous != next) widget.onOutputUpdate(context, next);
  }
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);
