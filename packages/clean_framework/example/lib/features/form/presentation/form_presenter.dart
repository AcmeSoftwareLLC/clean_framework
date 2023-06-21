import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/form/domain/form_ui_output.dart';
import 'package:clean_framework_example/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example/features/form/presentation/form_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter/material.dart';

class FormPresenter
    extends Presenter<FormViewModel, FormUIOutput, FormUseCase> {
  FormPresenter({
    required super.builder,
    super.key,
  }) : super(provider: formUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, FormUseCase useCase) {
    useCase.fetchAndPrefillData();
  }

  @override
  FormViewModel createViewModel(
    FormUseCase useCase,
    FormUIOutput output,
  ) {
    return FormViewModel(
      formController: output.formController,
      isLoading: output.isLoading,
      isLoggedIn: output.isLoggedIn,
      requireGender: output.requireGender,
      onLogin: useCase.login,
    );
  }

  @override
  void onOutputUpdate(BuildContext context, FormUIOutput output) {
    if (output.isLoggedIn) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final meta = output.userMeta;

          return AlertDialog(
            title: const Text('Login Success'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Email: ${meta.email}'),
                Text('Password: ${meta.password}'),
                Text('Gender: ${meta.gender}'),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          );
        },
      );
    }
  }
}
