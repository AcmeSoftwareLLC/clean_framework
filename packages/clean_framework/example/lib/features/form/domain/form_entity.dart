import 'package:clean_framework/clean_framework.dart';

class FormEntity extends Entity {
  const FormEntity({this.id = ''});

  final String id;

  @override
  List<Object> get props => [id];

  @override
  FormEntity copyWith({String? id}) {
    return FormEntity(id: id ?? this.id);
  }
}
