import 'package:clean_framework/clean_framework.dart';

enum FormTags {
  email,
  password,
  gender,
  selectGender,
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
    this.requireGender = true,
  });

  final FormController formController;
  final FormState state;
  final UserMeta userMeta;
  final bool requireGender;

  @override
  List<Object> get props => [formController, state, userMeta, requireGender];

  @override
  FormEntity copyWith({
    FormState? state,
    UserMeta? userMeta,
    bool? requireGender,
  }) {
    return FormEntity(
      formController: formController,
      state: state ?? this.state,
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
