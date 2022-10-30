import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/material.dart';

abstract class UI<V extends ViewModel> extends StatefulWidget {
  late final PresenterCreator<V>? _create;
  UI({
    Key? key,
    PresenterCreator<V>? create,
  }) : super(key: key) {
    _create = create ?? this.create;
  }

  Widget build(BuildContext context, V viewModel);

  Presenter create(PresenterBuilder<V> builder);

  @override
  // ignore: library_private_types_in_public_api
  _UIState createState() => _UIState<V>();
}

class _UIState<V extends ViewModel> extends State<UI<V>> {
  @override
  Widget build(BuildContext context) {
    return widget._create!
        .call((viewModel) => widget.build(context, viewModel));
  }
}

typedef PresenterCreator<V extends ViewModel> = Presenter Function(
    PresenterBuilder<V> builder);

typedef UIBuilder<V extends ViewModel> = Widget Function(
    BuildContext context, V viewModel);
