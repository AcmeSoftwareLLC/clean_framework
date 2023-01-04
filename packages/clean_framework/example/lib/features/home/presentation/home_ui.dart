import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/home/presentation/home_presenter.dart';
import 'package:clean_framework_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_example/widgets/pokemon_search_field.dart';
import 'package:clean_framework_example/widgets/svg_palette_card.dart';
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
      margin: EdgeInsets.symmetric(vertical: 8),
      builder: (context, picture) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w300),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2,
                ),
                child: picture,
              ),
            ],
          ),
        );
      },
      backgroundColorBuilder: (context, palette) {
        final color = Theme.of(context).brightness == Brightness.light
            ? palette.lightVibrantColor?.color
            : palette.darkVibrantColor?.color;

        return color?.withAlpha(120);
      },
    );
  }
}
