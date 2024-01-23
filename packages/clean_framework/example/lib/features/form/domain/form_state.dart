import 'package:clean_framework/clean_framework.dart';

enum FormTags {
  email,
  password,
  gender,
  selectGender,
}

enum FormScreenState {
  initial,
  loading,
  success,
  failure,
}

class FormState extends Entity {
  FormState({
    required this.formController,
    this.screenState = FormScreenState.initial,
    this.userMeta = const UserMeta(),
    this.requireGender = true,
  });

  final FormController formController;
  final FormScreenState screenState;
  final UserMeta userMeta;
  final bool requireGender;

  @override
  List<Object> get props =>
      [formController, screenState, userMeta, requireGender];

  @override
  FormState copyWith({
    FormScreenState? screenState,
    UserMeta? userMeta,
    bool? requireGender,
  }) {
    return FormState(
      formController: formController,
      screenState: screenState ?? this.screenState,
      userMeta: userMeta ?? this.userMeta,
      requireGender: requireGender ?? this.requireGender,
    );
  }
}

class UserMeta extends Entity {
  const UserMeta({
    this.email = '',
    this.password = '',
    this.gender = '',
  });

  final String email;
  final String password;
  final String gender;

  @override
  List<Object> get props => [email, password, gender];
}

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.name);

  final String name;
}
