import 'package:clean_framework/clean_framework.dart';

class FormUIOutput extends Output {
  const FormUIOutput({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
