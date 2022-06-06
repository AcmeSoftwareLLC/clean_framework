import 'package:clean_framework/src/open_feature/open_feature.dart';
import 'package:flutter/material.dart';

class FeatureBuilder<T extends Object> extends StatefulWidget {
  const FeatureBuilder({
    super.key,
    required this.flagKey,
    required this.defaultValue,
    required this.builder,
  });

  final String flagKey;
  final T defaultValue;
  final Widget Function(BuildContext, T) builder;

  @override
  State<FeatureBuilder<T>> createState() => _FeatureBuilderState<T>();
}

class _FeatureBuilderState<T extends Object> extends State<FeatureBuilder<T>> {
  late final FeatureClient _client;

  @override
  void initState() {
    super.initState();
    _client = OpenFeature.instance.getClient();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      initialData: widget.defaultValue,
      future: _client.getValue(
        key: widget.flagKey,
        defaultValue: widget.defaultValue,
      ),
      builder: (context, snapshot) {
        return widget.builder(context, snapshot.data!);
      },
    );
  }
}
