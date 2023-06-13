import 'package:clean_framework/clean_framework.dart';

import 'package:clean_framework_example/features/form/domain/form_entity.dart';
import 'package:clean_framework_example/features/form/domain/form_ui_output.dart';

class FormUseCase extends UseCase<FormEntity> {
  FormUseCase()
      : super(
          entity: const FormEntity(),
          transformers: [FormUIOutputTransformer()],
        );

  void updateId(String id) {
    entity = entity.copyWith(id: id);
  }
}

class FormUIOutputTransformer
    extends OutputTransformer<FormEntity, FormUIOutput> {
  @override
  FormUIOutput transform(FormEntity entity) {
    return FormUIOutput(id: entity.id);
  }
}
