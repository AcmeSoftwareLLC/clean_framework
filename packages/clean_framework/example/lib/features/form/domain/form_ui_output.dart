import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/form/domain/form_entity.dart';

class FormUIOutput extends Output {
  const FormUIOutput({
    required this.formController,
    required this.isLoading,
    required this.isLoggedIn,
    required this.userMeta,
    required this.requireGender,
  });

  final FormController formController;
  final bool isLoading;
  final bool isLoggedIn;
  final UserMeta userMeta;
  final bool requireGender;

  @override
  List<Object> get props {
    return [formController, isLoading, isLoggedIn, userMeta, requireGender];
  }
}
