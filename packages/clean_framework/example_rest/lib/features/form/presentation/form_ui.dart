import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_entity.dart';
import 'package:clean_framework_example_rest/features/form/presentation/form_presenter.dart';
import 'package:clean_framework_example_rest/features/form/presentation/form_view_model.dart';
import 'package:clean_framework_example_rest/widgets/fields.dart';
import 'package:flutter/material.dart';

class FormUI extends UI<FormViewModel> {
  FormUI({super.key});

  @override
  FormPresenter create(WidgetBuilder builder) {
    return FormPresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, FormViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: InputForm(
              controller: viewModel.formController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TextInputField(
                    tag: FormTags.email,
                    hintText: 'Email',
                  ),
                  const SizedBox(height: 16),
                  const TextInputField(
                    tag: FormTags.password,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  const CheckboxInputField(
                    tag: FormTags.selectGender,
                    label: 'Select Gender?',
                  ),
                  if (viewModel.requireGender)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: DropdownInputField(
                        tag: FormTags.gender,
                        hintText: 'Gender',
                        menuEntries: [
                          for (final gender in Gender.values)
                            DropdownMenuEntry(
                              value: gender,
                              label: gender.name,
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 40),
                  FormButton(
                    onPressed: viewModel.onLogin,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
