import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/validators/validators.dart';
import 'package:clean_framework_example/features/form/domain/form_entity.dart';
import 'package:clean_framework_example/features/form/domain/form_ui_output.dart';

class FormUseCase extends UseCase<FormEntity> {
  FormUseCase()
      : super(
          useCaseState: FormEntity(
            formController: FormController(
              validators: {const InputFieldValidator.required()},
            ),
          ),
          transformers: [FormUIOutputTransformer()],
        ) {
    _emailController = TextFieldController.create(
      useCaseState.formController,
      tag: FormTags.email,
    )..setValidators({const EmailInputFieldValidator()});
    _passwordController = TextFieldController.create(
      useCaseState.formController,
      tag: FormTags.password,
      autoValidate: true,
    )..setValidators({const PasswordInputFieldValidator()});
    _genderController = FieldController.create(
      useCaseState.formController,
      tag: FormTags.gender,
    )..setInitialValue(Gender.female);

    FieldController<bool>.create(
      useCaseState.formController,
      tag: FormTags.selectGender,
    )
      ..setInitialValue(true)
      ..onUpdate(_onSelectGenderUpdate);
  }

  late final TextFieldController _emailController;
  late final TextFieldController _passwordController;
  late final FieldController<Gender> _genderController;

  Future<void> fetchAndPrefillData() async {
    // Simulates fetching form data from api
    await Future<void>.delayed(const Duration(seconds: 1));

    useCaseState.formController(FormTags.selectGender).setValue(false);
  }

  Future<void> login() async {
    final formController = useCaseState.formController;
    if (formController.validate()) {
      useCaseState = useCaseState.copyWith(state: FormState.loading);
      formController.setSubmitted(true);

      // Simulates login
      await Future<void>.delayed(const Duration(seconds: 1));

      final userMeta = UserMeta(
        email: _emailController.value ?? '',
        password: _passwordController.value ?? '',
        gender: _genderController.value?.name ?? '',
      );
      useCaseState =
          useCaseState.copyWith(state: FormState.success, userMeta: userMeta);
      formController.setSubmitted(false);

      useCaseState = useCaseState.copyWith(state: FormState.initial);
    }
  }

  void _onSelectGenderUpdate(bool? selectGender) {
    useCaseState = useCaseState.copyWith(requireGender: selectGender ?? false);
  }

  @override
  void dispose() {
    useCaseState.formController.dispose();
    super.dispose();
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
      requireGender: entity.requireGender,
    );
  }
}
