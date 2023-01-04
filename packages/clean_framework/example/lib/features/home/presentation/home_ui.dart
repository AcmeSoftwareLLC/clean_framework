import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/widgets/pokemon_card.dart';
import 'package:clean_framework_example/widgets/pokemon_search_field.dart';
import 'package:flutter/material.dart';

class HomeUI extends UI<HomeViewModel> {
  @override
  HomePresenter create(PresenterBuilder<HomeViewModel> builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pokémon'),
        centerTitle: false,
        titleTextStyle: textTheme.displaySmall!.copyWith(
          fontWeight: FontWeight.w300,
        ),
        bottom: PokemonSearchField(onChanged: viewModel.onSearch),
      ),
      body: ListView.builder(
        prototypeItem: SizedBox(height: 176), // 160 + 16
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final pokemon = viewModel.pokemons[index];

          return PokemonCard(
            imageUrl: pokemon.imageUrl,
            name: pokemon.name,
          );
        },
        itemCount: viewModel.pokemons.length,
      ),
    );
  }
}
