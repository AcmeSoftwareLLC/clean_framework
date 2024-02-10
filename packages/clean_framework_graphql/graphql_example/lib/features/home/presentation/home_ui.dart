import 'package:graphql_example/features/home/presentation/home_presenter.dart';
import 'package:graphql_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

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
        title: const Text('Clean Framework GraphQL Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 160.0,
            ),
            Text(
              'Random Pokemon Data (limit 100 per hour):',
              style: themeData.textTheme.labelMedium,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              'Pokemon ID: ${viewModel.pokemonId}',
              style: themeData.textTheme.labelSmall,
            ),
            Text(
              'Pokemon Name: ${viewModel.pokemonName}',
              style: themeData.textTheme.labelSmall,
            ),
            Text(
              'Pokemon Order: ${viewModel.pokemonOrder}',
              style: themeData.textTheme.labelSmall,
            ),
            Text(
              'Pokemon Weight: ${viewModel.pokemonWeight}',
              style: themeData.textTheme.labelSmall,
            ),
            Text(
              'Pokemon Height: ${viewModel.pokemonHeight}',
              style: themeData.textTheme.labelSmall,
            ),
            const SizedBox(
              height: 24.0,
            ),
            ElevatedButton(
              onPressed: viewModel.onRefreshAbility,
              child: const Text("Get New Pokemon"),
            ),
          ],
        ),
      ),
    );
  }
}
