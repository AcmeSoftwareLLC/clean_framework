import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_domain_models.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example_rest/features/form/presentation/form_view_model.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:flutter/material.dart';

class FormPresenter
    extends Presenter<FormViewModel, FormDomainToUIModel, FormUseCase> {
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
    FormDomainToUIModel domainModel,
  ) {
    return FormViewModel(
      formController: domainModel.formController,
      isLoading: domainModel.isLoading,
      isLoggedIn: domainModel.isLoggedIn,
      requireGender: domainModel.requireGender,
      onLogin: useCase.login,
    );
  }

  @override
  void onDomainModelUpdate(
      BuildContext context, FormDomainToUIModel domainModel) {
    if (domainModel.isLoggedIn) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final meta = domainModel.userMeta;

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
