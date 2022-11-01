import 'package:clean_framework/src/feature_state/feature.dart';
import 'package:clean_framework/src/feature_state/feature_mapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// An instance of this class creates a [FeatureMapper] implementation
/// that uses a specific data type to represent the states of each
/// [Feature].
///
/// You can create a global instance to allow any FeatureWidget to
/// build a specific UI hierarchy based on the current state for
/// the [Feature] associated to it.
///
/// This is a callable class, but the callable method is only useful
/// for the internal code of FeatureWidget and there is no practical
/// use for it. Developers should be calling [featuresMap] to retrieve
/// the mapper and obtain the states that way.
class FeatureStateProvider<S, F extends FeatureMapper<S>> {
  FeatureStateProvider(this.create)
      : _provider = StateNotifierProvider<F, Map<Feature, S>>(create);

  final StateNotifierProvider<F, Map<Feature, S>> _provider;
  final F Function(Ref) create;

  // Direct call to retrieve the state, which is just the map,
  // for example when using ref.watch
  StateNotifierProvider<F, Map<Feature, S>> call() => _provider;

  // Used to have access to the Mapper class, for example to call load()
  AlwaysAliveRefreshable<F> get featuresMap => _provider.notifier;
}
