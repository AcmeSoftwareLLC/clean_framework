import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A container that holds all the app providers.
class AppProvidersContainer extends StatelessWidget {
  /// Default constructor.
  AppProvidersContainer({
    super.key,
    required this.child,
    ProvidersContext? providersContext,
    Function(BuildContext, ProvidersContext)? onBuild,
  })  : _providersContext = providersContext ?? ProvidersContext(),
        _onBuild = onBuild;

  /// The widget below this widget in the tree.
  final Widget child;

  final ProvidersContext _providersContext;
  final Function(BuildContext, ProvidersContext)? _onBuild;

  @override
  Widget build(BuildContext context) {
    _onBuild?.call(context, _providersContext);

    return UncontrolledProviderScope(
      container: _providersContext(),
      child: child,
    );
  }
}

/// A class to hold the [ProviderContainer].
class ProvidersContext {
  final ProviderContainer _container;

  /// Default constructor.
  ProvidersContext([
    List<Override> overrides = const [],
  ]) : _container = ProviderContainer(overrides: overrides);

  /// The [ProviderContainer].
  ProviderContainer call() => _container;

  /// Release all the resources associated with this [ProviderContainer].
  void dispose() {
    _container.dispose();
  }
}
