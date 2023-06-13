import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

import 'package:clean_framework_example/features/form/presentation/form_view_model.dart';
import 'package:clean_framework_example/features/form/presentation/form_presenter.dart';

class FormUI extends UI<FormViewModel> {
  FormUI({super.key});

  @override
  FormPresenter create(WidgetBuilder builder) {
    return FormPresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, FormViewModel viewModel) {
    return Scaffold(
      body: Center(
        child: Text(viewModel.id),
      ),
    );
  }
}
