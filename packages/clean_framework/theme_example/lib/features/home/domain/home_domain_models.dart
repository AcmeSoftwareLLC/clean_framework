import 'package:clean_framework/clean_framework.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';

class HomeDomainToUIModel extends DomainModel {
  const HomeDomainToUIModel({
    required this.appTheme,
  });

  final AppTheme appTheme;

  @override
  List<Object?> get props => [
        appTheme,
      ];
}

class HomeThemeDomainToUIModel extends DomainModel {
  const HomeThemeDomainToUIModel({
    required this.appTheme,
  });

  final AppTheme appTheme;

  @override
  List<Object> get props => [
        appTheme,
      ];
}
