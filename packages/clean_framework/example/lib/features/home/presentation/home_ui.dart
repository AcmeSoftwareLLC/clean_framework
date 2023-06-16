import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/routing/routes.dart';
import 'package:clean_framework_example/widgets/pokemon_card.dart';
import 'package:clean_framework_example/widgets/pokemon_search_field.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter/material.dart';

class HomeUI extends UI<HomeViewModel> {
  @override
  HomePresenter create(WidgetBuilder builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    Widget child;
    if (viewModel.isLoading) {
      child = Center(child: CircularProgressIndicator());
    } else if (viewModel.hasFailedLoading) {
      child = _LoadingFailed(onRetry: viewModel.onRetry);
    } else {
      child = RefreshIndicator(
        onRefresh: viewModel.onRefresh,
        child: ListView.builder(
          prototypeItem: SizedBox(height: 176), // 160 + 16
          padding: EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final pokemon = viewModel.pokemons[index];

            return PokemonCard(
              key: ValueKey(pokemon.name),
              imageUrl: pokemon.imageUrl,
              name: pokemon.name,
              heroTag: pokemon.name,
              onTap: () {
                context.router.go(
                  Routes.profile,
                  params: {'pokemon_name': pokemon.name},
                  queryParams: {'image': pokemon.imageUrl},
                );
              },
            );
          },
          itemCount: viewModel.pokemons.length,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon'),
        centerTitle: false,
        titleTextStyle: textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w300,
        ),
        toolbarHeight: 100,
        bottom: viewModel.isLoading || viewModel.hasFailedLoading
            ? null
            : PokemonSearchField(onChanged: viewModel.onSearch),
        actions: [
          if (viewModel.loggedInEmail.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Logged in as:',
                  style: textTheme.labelMedium,
                ),
                Text(
                  viewModel.loggedInEmail,
                  style: textTheme.labelSmall,
                ),
              ],
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.router.go(Routes.form),
        child: Icon(Icons.format_align_center),
      ),
    );
  }
}

class _LoadingFailed extends StatelessWidget {
  const _LoadingFailed({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Image.asset('assets/sad-flareon.png', height: 300),
          ),
          const SizedBox(height: 8),
          Text(
            'Oops',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 8),
          Text('I lost my fellow Pokémons'),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onRetry,
            child: Text('Help Flareon, find her friends'),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
