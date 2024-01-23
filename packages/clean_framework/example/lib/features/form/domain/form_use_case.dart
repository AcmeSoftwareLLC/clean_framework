import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/core/validators/validators.dart';
import 'package:clean_framework_example/features/form/domain/form_state.dart';
import 'package:clean_framework_example/features/form/domain/form_domain_outputs.dart';

class FormUseCase extends UseCase<FormState> {
  FormUseCase()
      : super(
          entity: FormState(
            formController: FormController(
              validators: {const InputFieldValidator.required()},
            ),
          ),
          transformers: [FormDomainToUIOutputTransformer()],
        ) {
    _emailController = TextFieldController.create(
      entity.formController,
      tag: FormTags.email,
    )..setValidators({const EmailInputFieldValidator()});
    _passwordController = TextFieldController.create(
      entity.formController,
      tag: FormTags.password,
      autoValidate: true,
    )..setValidators({const PasswordInputFieldValidator()});
    _genderController = FieldController.create(
      entity.formController,
      tag: FormTags.gender,
    )..setInitialValue(Gender.female);

    FieldController<bool>.create(
      entity.formController,
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

    entity.formController(FormTags.selectGender).setValue(false);
  }

  Future<void> login() async {
    final formController = entity.formController;
    if (formController.validate()) {
      entity = entity.copyWith(screenState: FormScreenState.loading);
      formController.setSubmitted(true);

      // Simulates login
      await Future<void>.delayed(const Duration(seconds: 1));

      final userMeta = UserMeta(
        email: _emailController.value ?? '',
        password: _passwordController.value ?? '',
        gender: _genderController.value?.name ?? '',
      );
      entity = entity.copyWith(
          screenState: FormScreenState.success, userMeta: userMeta);
      formController.setSubmitted(false);

      entity = entity.copyWith(screenState: FormScreenState.initial);
    }
  }

  void _onSelectGenderUpdate(bool? selectGender) {
    entity = entity.copyWith(requireGender: selectGender ?? false);
  }

  @override
  void dispose() {
    entity.formController.dispose();
    super.dispose();
  }
}

class FormDomainToUIOutputTransformer
    extends OutputTransformer<FormState, FormDomainToUIOutput> {
  @override
  FormDomainToUIOutput transform(FormState state) {
    return FormDomainToUIOutput(
      formController: state.formController,
      isLoading: state.screenState == FormScreenState.loading,
      isLoggedIn: state.screenState == FormScreenState.success,
      userMeta: state.userMeta,
      requireGender: state.requireGender,
    );
  }
}
