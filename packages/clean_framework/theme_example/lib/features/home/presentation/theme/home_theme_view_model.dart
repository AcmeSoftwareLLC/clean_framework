import 'package:clean_framework/clean_framework.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';

class HomeThemeViewModel extends ViewModel {
  const HomeThemeViewModel({
    required this.appTheme,
  });

  final AppTheme appTheme;

  @override
  List<Object> get props => [
        appTheme,
      ];
}
