import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/core/validators/validators.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_entity.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_domain_models.dart';

class FormUseCase extends UseCase<FormEntity> {
  FormUseCase()
      : super(
          entity: FormEntity(
            formController: FormController(
              validators: {const InputFieldValidator.required()},
            ),
          ),
          transformers: [FormDomainToUIModelTransformer()],
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

      final userMeta = UserMetaEntity(
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

class FormDomainToUIModelTransformer
    extends DomainModelTransformer<FormEntity, FormDomainToUIModel> {
  @override
  FormDomainToUIModel transform(FormEntity entity) {
    return FormDomainToUIModel(
      formController: entity.formController,
      isLoading: entity.screenState == FormScreenState.loading,
      isLoggedIn: entity.screenState == FormScreenState.success,
      userMeta: entity.userMeta,
      requireGender: entity.requireGender,
    );
  }
}
