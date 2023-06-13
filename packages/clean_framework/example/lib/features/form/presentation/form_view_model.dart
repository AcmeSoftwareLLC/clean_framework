import 'package:clean_framework/clean_framework.dart';

class FormViewModel extends ViewModel {
  const FormViewModel({required this.id});

  final String id;

  @override
  List<Object> get props => [id];
}
