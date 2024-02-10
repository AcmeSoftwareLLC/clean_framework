import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';
import 'package:theme_example/features/home/presentation/home_presenter.dart';
import 'package:theme_example/features/home/presentation/home_view_model.dart';

class HomeUI extends UI<HomeViewModel> {
  HomeUI({
    super.key,
  });

  @override
  HomePresenter create(WidgetBuilder builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(viewModel.appTheme.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 36,
            ),
            Text(
              'Select App Theme',
              style: themeData.textTheme.labelMedium,
            ),
            ...AppTheme.values.map(
              (theme) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: RadioListTile(
                  value: theme,
                  groupValue: viewModel.appTheme,
                  title: Text(
                    theme.name,
                    style: themeData.textTheme.labelMedium!.copyWith(
                      color: theme == viewModel.appTheme
                          ? themeData.colorScheme.primary
                          : themeData.colorScheme.onBackground,
                    ),
                  ),
                  onChanged: viewModel.onThemeChange,
                  contentPadding: const EdgeInsets.all(4),
                  tileColor: theme == viewModel.appTheme
                      ? themeData.colorScheme.primaryContainer
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: themeData.colorScheme.outline,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
