import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/foundation.dart';

class FormViewModel extends ViewModel {
  const FormViewModel({
    required this.formController,
    required this.onLogin,
    required this.isLoading,
    required this.requireGender,
    required this.isLoggedIn,
  });

  final FormController formController;
  final bool isLoading;
  final bool isLoggedIn;
  final bool requireGender;

  final VoidCallback onLogin;

  @override
  List<Object> get props {
    return [formController, isLoading, isLoggedIn, requireGender];
  }
}
