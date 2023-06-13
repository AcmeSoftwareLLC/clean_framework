import 'package:clean_framework/clean_framework.dart';

import 'package:clean_framework_example/features/form/domain/form_ui_output.dart';
import 'package:clean_framework_example/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example/features/form/presentation/form_view_model.dart';
import 'package:clean_framework_example/providers.dart';

class FormPresenter
    extends Presenter<FormViewModel, FormUIOutput, FormUseCase> {
  FormPresenter({
    required super.builder,
    super.key,
  }) : super(provider: formUseCaseProvider);

  @override
  FormViewModel createViewModel(
    FormUseCase useCase,
    FormUIOutput output,
  ) {
    return FormViewModel(id: output.id);
  }
}
