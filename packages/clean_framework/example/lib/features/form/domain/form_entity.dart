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

class FormEntity extends Entity {
  FormEntity({
    required this.formController,
    this.screenState = FormScreenState.initial,
    this.userMeta = const UserMetaEntity(),
    this.requireGender = true,
  });

  final FormController formController;
  final FormScreenState screenState;
  final UserMetaEntity userMeta;
  final bool requireGender;

  @override
  List<Object> get props =>
      [formController, screenState, userMeta, requireGender];

  @override
  FormEntity copyWith({
    FormScreenState? screenState,
    UserMetaEntity? userMeta,
    bool? requireGender,
  }) {
    return FormEntity(
      formController: formController,
      screenState: screenState ?? this.screenState,
      userMeta: userMeta ?? this.userMeta,
      requireGender: requireGender ?? this.requireGender,
    );
  }
}

class UserMetaEntity extends Entity {
  const UserMetaEntity({
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
