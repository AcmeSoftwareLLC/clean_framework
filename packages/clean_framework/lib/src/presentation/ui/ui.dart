import 'package:clean_framework/src/presentation/presentation.dart';
import 'package:flutter/material.dart';

abstract class UI<V extends ViewModel> extends StatefulWidget {
  UI({
    super.key,
    PresenterCreator? create,
  }) {
    _create = create ?? this.create;
  }

  late final PresenterCreator _create;

  @override
  State<UI<V>> createState() => _UIState<V>();

  Widget build(BuildContext context, V viewModel);

  Presenter create(WidgetBuilder builder);
}

class _UIState<V extends ViewModel> extends State<UI<V>> {
  @override
  Widget build(BuildContext context) {
    return widget._create.call(
      (context) => widget.build(context, context.viewModel()),
    );
  }
}

typedef PresenterCreator = Presenter Function(WidgetBuilder builder);
