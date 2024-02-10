import 'package:clean_framework/clean_framework.dart';

class HomeEntity extends Entity {
  const HomeEntity({
    this.appTheme = AppTheme.light,
  });

  final AppTheme appTheme;

  @override
  HomeEntity copyWith({
    AppTheme? appTheme,
  }) {
    return HomeEntity(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  List<Object?> get props => [
        appTheme,
      ];
}

enum AppTheme {
  light(name: 'Light Theme', value: 'LIGHT'),
  dark(name: 'Dark Theme', value: 'DARK');

  const AppTheme({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;
}
