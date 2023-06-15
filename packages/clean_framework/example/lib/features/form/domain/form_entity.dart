import 'package:clean_framework/clean_framework.dart';

enum FormTags {
  email,
  password,
  gender,
  rememberMe,
}

enum FormState {
  initial,
  loading,
  success,
  failure,
}

class FormEntity extends Entity {
  FormEntity({
    required this.formController,
    this.state = FormState.initial,
    this.userMeta = const UserMeta(),
  });

  final FormController formController;
  final FormState state;
  final UserMeta userMeta;

  @override
  List<Object> get props => [formController, state, userMeta];

  @override
  FormEntity copyWith({
    FormState? state,
    UserMeta? userMeta,
  }) {
    return FormEntity(
      formController: formController,
      state: state ?? this.state,
      userMeta: userMeta ?? this.userMeta,
    );
  }
}

class UserMeta extends Entity {
  const UserMeta({
    this.email = '',
    this.password = '',
    this.gender = '',
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final String gender;
  final bool rememberMe;

  @override
  List<Object> get props => [email, password, gender, rememberMe];
}

enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  const Gender(this.name);

  final String name;
}
