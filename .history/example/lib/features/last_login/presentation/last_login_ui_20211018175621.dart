import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/last_login/presentation/last_login_presenter.dart';
import 'package:flutter/material.dart';

import 'last_login_view_model.dart';

class LastLoginUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Last Login')),
      body: Center(
        child: Column(
          children: <Widget>[
            Card(
                child: Text(
                    'This example shows how the screen can be fractionalized '
                    'in multiple presenters and view models.')),
            LastLoginISODateUI(),
            LastLoginShortDateUI(),
            LastLoginCTADateUI(),
          ],
        ),
      ),
    );
  }
}

class LastLoginISODateUI extends UI<LastLoginISOViewModel> {
  // In order to create clean tests with mocked presenters, this constructor
  // needs to exist so the create method could be overriden during the test
  // Please see the UI test for this class
  LastLoginISODateUI({PresenterCreator<LastLoginISOViewModel>? create})
      : super(create: create);
  @override
  create(PresenterBuilder<LastLoginISOViewModel> builder) {
    return LastLoginIsoDatePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, LastLoginISOViewModel viewModel) {
    return Card(
      child: ListTile(
        title: Text('Full Date'),
        subtitle: Text(
          viewModel.isoDate,
        ),
      ),
    );
  }
}

class LastLoginShortDateUI extends UI<LastLoginShortViewModel> {
  LastLoginShortDateUI({PresenterCreator<LastLoginShortViewModel>? create})
      : super(create: create);
  @override
  create(PresenterBuilder<LastLoginShortViewModel> builder) {
    return LastLoginShortDatePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, LastLoginShortViewModel viewModel) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Short Date'),
            subtitle: Text(
              viewModel.shortDate,
            ),
          ),
        ],
      ),
    );
  }
}

class LastLoginCTADateUI extends UI<LastLoginCTAViewModel> {
  LastLoginCTADateUI({PresenterCreator<LastLoginCTAViewModel>? create})
      : super(create: create);
  @override
  create(PresenterBuilder<LastLoginCTAViewModel> builder) {
    return LastLoginCTAPresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, LastLoginCTAViewModel viewModel) {
    return Card(
      child: viewModel.isLoading
          ? _loadingButton()
          : _defaultButton(viewModel.fetchCurrentDate),
    );
  }

  Widget _loadingButton() {
    return ElevatedButton(
      child: CircularProgressIndicator(),
      onPressed: null,
    );
  }

  Widget _defaultButton(VoidCallback callback) {
    return ElevatedButton(
      child: Text('Fetch Date'),
      onPressed: callback,
    );
  }
}
