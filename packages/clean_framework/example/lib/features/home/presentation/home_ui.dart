import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/widgets/svg_palette_card.dart';
import 'package:flutter/material.dart';

class HomeUI extends UI<HomeViewModel> {
  @override
  HomePresenter create(PresenterBuilder<HomeViewModel> builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokemon'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final pokemon = viewModel.pokemons[index];

          return _PokemonCard(imageUrl: pokemon.imageUrl, name: pokemon.name);
        },
        itemCount: viewModel.pokemons.length,
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  const _PokemonCard({required this.imageUrl, required this.name});

  final String imageUrl;
  final String name;

  @override
  Widget build(BuildContext context) {
    return SvgPaletteCard(
      url: imageUrl,
      height: 160,
      builder: (context, picture) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              picture,
              Text(name),
            ],
          ),
        );
      },
    );
  }
}
