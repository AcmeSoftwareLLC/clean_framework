import 'dart:async';

import 'package:clean_framework/src/core/core.dart';
import 'package:clean_framework/src/presentation/presenter/view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class Presenter<
  V extends ViewModel,
  M extends DomainModel,
  U extends UseCase
>
    extends ConsumerStatefulWidget {
  const Presenter({
    required this.provider,
    required this.builder,
    super.key,
  }) : _arg = const _NoArg(),
       _family = null;

  Presenter.family({
    required UseCaseProviderFamilyBase family,
    required Object arg,
    required this.builder,
    super.key,
  }) : _arg = arg,
       provider = family(arg),
       _family = family;

  @visibleForTesting
  final UseCaseProviderBase provider;
  final WidgetBuilder builder;
  final UseCaseProviderFamilyBase? _family;
  final Object _arg;

  @override
  ConsumerState<Presenter<V, M, U>> createState() => _PresenterState<V, M, U>();

  @protected
  V createViewModel(U useCase, M domainModel);

  /// Called when this presenter is inserted into the tree.
  @protected
  void onLayoutReady(BuildContext context, U useCase) {}

  /// Called whenever the [domainModel] updates.
  @protected
  void onDomainModelUpdate(BuildContext context, M domainModel) {}

  @Deprecated('Use onDomainModelUpdate.')
  @protected
  void onOutputUpdate(BuildContext context, M output) =>
      onDomainModelUpdate(context, output);

  /// Called whenever a new output is received.
  @protected
  @mustCallSuper
  void onDomainModel(
    BuildContext context,
    DomainModelState<M> domainModel,
    V viewModel,
  ) {
    if (domainModel.hasUpdated) onDomainModelUpdate(context, domainModel.next);
  }

  @Deprecated('Use onDomainModel.')
  @protected
  @mustCallSuper
  void onOutput(
    BuildContext context,
    DomainModelState<M> output,
    V viewModel,
  ) => onDomainModel(context, output, viewModel);

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
  M subscribe(WidgetRef ref) => provider.subscribe<M>(ref);
}

class _PresenterState<
  V extends ViewModel,
  M extends DomainModel,
  U extends UseCase
>
    extends ConsumerState<Presenter<V, M, U>> {
  U? _useCase;
  late final UseCaseProviderBase _provider;

  @override
  WidgetRef get ref => context as WidgetRef;

  @override
  void initState() {
    super.initState();
    _provider = initProvider();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _useCase ??= _provider.getUseCase(ref) as U;
  }

  @override
  void didUpdateWidget(covariant Presenter<V, M, U> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdatePresenter(context, oldWidget, _useCase!);
  }

  @override
  Widget build(BuildContext context) {
    var viewModel = ViewModelScope.maybeOf<V>(context);

    if (viewModel == null) {
      final domainModel = widget.subscribe(ref);
      viewModel = widget.createViewModel(_useCase!, domainModel);

      _provider.listen<M>(
        ref,
        (p, n) =>
            widget.onDomainModel(context, DomainModelState(p, n), viewModel!),
      );
    }

    return ViewModelScope<V>(
      viewModel: viewModel,
      child: ViewModelBuilder(builder: widget.builder),
    );
  }

  @override
  void dispose() {
    widget.onDestroy(_useCase!);
    super.dispose();
  }

  UseCaseProviderBase initProvider() {
    final provider = widget.provider;
    final arg = widget._arg;

    if (arg is _NoArg) {
      unawaited(
        provider.notifier.first.then((_) => setLayoutReadyIfViewModelFound()),
      );
      provider.init();
    } else {
      final family = widget._family!;
      unawaited(
        family.notifier
            .firstWhere((e) => e.$2 == arg)
            .then((_) => setLayoutReadyIfViewModelFound()),
      );
      family.init(arg);
    }

    return provider;
  }

  void setLayoutReadyIfViewModelFound() {
    if (ViewModelScope.maybeOf<V>(context) == null) {
      widget.onLayoutReady(context, _useCase!);
    }
  }
}

class ViewModelBuilder extends StatelessWidget {
  /// Creates a widget that delegates its build to a callback.
  ///
  /// The [builder] argument must not be null.
  const ViewModelBuilder({
    required this.builder,
    super.key,
  });

  /// Called to obtain the child widget.
  ///
  /// This function is called whenever this widget is included in its parent's
  /// build and the old widget (if any) that it synchronizes with has a distinct
  /// object identity. Typically the parent's build method will construct
  /// a new tree of widgets and so a new Builder child will not be [identical]
  /// to the corresponding old one.
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

typedef PresenterBuilder<V extends ViewModel> = Widget Function(V viewModel);

class DomainModelState<M extends DomainModel> {
  DomainModelState(this.previous, this.next);

  final M? previous;
  final M next;

  bool get hasUpdated => previous != next;
}

class ViewModelScope<V extends ViewModel> extends InheritedWidget {
  const ViewModelScope({
    required super.child,
    required this.viewModel,
    super.key,
  });

  final V viewModel;

  static V of<V extends ViewModel>(BuildContext context) {
    final viewModel = maybeOf<V>(context);
    assert(viewModel != null, 'No ViewModelScope<$V> found in context');
    return viewModel!;
  }

  static V? maybeOf<V extends ViewModel>(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ViewModelScope<V>>();
    return result?.viewModel;
  }

  @override
  bool updateShouldNotify(ViewModelScope oldWidget) {
    return oldWidget.viewModel != viewModel;
  }
}

extension ViewModelScopeExtension on BuildContext {
  @useResult
  V viewModel<V extends ViewModel>() => ViewModelScope.of<V>(this);
}

class _NoArg extends Object {
  const _NoArg();
}
