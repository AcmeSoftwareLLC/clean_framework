import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/feature_state/feature_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature.dart';

/// For each feature entry point, a FeatureWidget instance is used to control
/// the visibility and behavior of the children. One FeatureWidget could have
/// many UI widgets, one per each state.
///
/// The S on the generics declaration stands for the class that is going to use
/// to determine the possible value for a given state. The most common data
/// type used here is an enum. You are free to use anything that provides a
/// similar behavior.
///
/// The objects of this class need an existing Feature object and a
/// FeatureProvider object. The provider is used internally to extract the
/// current state for the given Feature, and use it as part of the [builder]
/// method.
abstract class FeatureWidget<S> extends ConsumerStatefulWidget {
  final FeatureStateProvider<S, FeatureMapper<S>> provider;
  final Feature feature;

  FeatureWidget({
    Key? key,
    required this.provider,
    required this.feature,
  }) : super(key: key);

  /// The override of this method should return the proper widget depending
  /// on the currentState value. A common pattern is to have states that
  /// instead of returning a visible widget, return an empty container.
  ///
  /// The developer can use hidden widget to return a simple empty container
  /// with a key that can by checked during tests.
  Widget builder(BuildContext context, S currentState);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeatureWidgetState<S>();
}

class _FeatureWidgetState<S> extends ConsumerState<FeatureWidget<S>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ref.watch(widget.provider());
  }

  @override
  Widget build(BuildContext context) {
    final mapper = ref.read(widget.provider.featuresMap);
    final currentState = mapper.getStateFor(widget.feature);

    //TODO THIS SHOULDN'T BE NEEDED, FIGURE OUT WHY THE REBUILD DOESN'T HAPPEN
    ref.listen(widget.provider(), (_, __) => setState(() {}));

    return widget.builder(context, currentState);
  }
}
