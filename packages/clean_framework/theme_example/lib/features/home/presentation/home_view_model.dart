import 'package:clean_framework/clean_framework.dart';
import 'package:material_ui/material_ui.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';

class HomeViewModel extends ViewModel {
  const HomeViewModel({required this.appTheme, required this.onThemeChange});

  final AppTheme appTheme;

  final ValueChanged<AppTheme?> onThemeChange;

  @override
  List<Object> get props => [appTheme];
}
