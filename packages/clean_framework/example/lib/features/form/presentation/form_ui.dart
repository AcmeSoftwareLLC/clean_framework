import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/form/domain/form_entity.dart';
import 'package:clean_framework_example/widgets/fields.dart';
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
      appBar: AppBar(title: const Text('Form Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: InputForm(
          controller: viewModel.formController,
          child: Column(
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
                autoValidate: true,
              ),
              const SizedBox(height: 16),
              DropdownInputField(
                tag: FormTags.gender,
                hintText: 'Gender',
                items: [
                  for (final gender in Gender.values)
                    DropdownMenuItem(value: gender, child: Text(gender.name)),
                ],
              ),
              const SizedBox(height: 16),
              const CheckboxInputField(
                tag: FormTags.rememberMe,
                label: 'Remember me',
              ),
              const SizedBox(height: 40),
              InputActionBuilder(
                builder: (context, controller, _) {
                  return FilledButton(
                    onPressed: controller.contains({InputFormState.touched})
                        ? viewModel.onLogin
                        : null,
                    child: const Text('Login'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}