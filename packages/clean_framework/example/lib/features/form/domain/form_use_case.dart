import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/validators/validators.dart';
import 'package:clean_framework_example/features/form/domain/form_entity.dart';
import 'package:clean_framework_example/features/form/domain/form_ui_output.dart';

class FormUseCase extends UseCase<FormEntity> {
  FormUseCase()
      : super(
          entity: FormEntity(
            formController: FormController(
              validators: {const InputFieldValidator.required()},
            ),
          ),
          transformers: [FormUIOutputTransformer()],
        );

  Future<void> initForm() async {
    final formController = entity.formController;
    final emailController = formController.getField(FormTags.email);
    emailController
      ..setValidators({const EmailInputFieldValidator()})
      ..setValue('sales@acme-software.com');

    final passwordController = formController.getField(FormTags.password);
    passwordController.setValidators({const PasswordInputFieldValidator()});
  }

  Future<void> login() async {
    final formController = entity.formController;
    if (formController.validate()) {
      entity = entity.copyWith(state: FormState.loading);
      formController.setSubmitted(true);

      // Simulates login
      await Future<void>.delayed(const Duration(seconds: 2));

      final userMeta = UserMeta(
        email: formController.getValue(FormTags.email) ?? '',
        password: formController.getValue(FormTags.password) ?? '',
        gender: formController.getValue<Gender>(FormTags.gender)?.name ?? '',
        rememberMe: formController.getValue(FormTags.rememberMe) ?? false,
      );
      entity = entity.copyWith(state: FormState.success, userMeta: userMeta);
      formController.setSubmitted(false);
    }
  }
}

class FormUIOutputTransformer
    extends OutputTransformer<FormEntity, FormUIOutput> {
  @override
  FormUIOutput transform(FormEntity entity) {
    return FormUIOutput(
      formController: entity.formController,
      isLoading: entity.state == FormState.loading,
      isLoggedIn: entity.state == FormState.success,
      userMeta: entity.userMeta,
    );
  }
}
