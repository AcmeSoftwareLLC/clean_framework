import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';
import 'package:theme_example/features/home/presentation/theme/home_theme_presenter.dart';
import 'package:theme_example/features/home/presentation/theme/home_theme_view_model.dart';

class ExampleThemeModeWrapper extends UI<HomeThemeViewModel> {
  ExampleThemeModeWrapper({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext, ThemeMode) builder;

  @override
  HomeThemePresenter create(WidgetBuilder builder) =>
      HomeThemePresenter(builder: builder);

  @override
  Widget build(BuildContext context, HomeThemeViewModel viewModel) {
    return builder(
      context,
      _getThemeMode(
        viewModel.appTheme,
      ),
    );
  }

  ThemeMode _getThemeMode(AppTheme theme) {
    return switch (theme) {
      AppTheme.light => ThemeMode.light,
      AppTheme.dark => ThemeMode.dark,
    };
  }
}
