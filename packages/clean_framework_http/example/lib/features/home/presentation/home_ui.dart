import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/material.dart';

import 'package:clean_framework_http_example/features/home/presentation/home_view_model.dart';
import 'package:clean_framework_http_example/features/home/presentation/home_presenter.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeUI extends UI<HomeViewModel> {
  HomeUI({super.key});

  @override
  HomePresenter create(WidgetBuilder builder) =>
      HomePresenter(builder: builder);

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    final titleStyle = Theme.of(context).textTheme.titleLarge!.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w300,
        );

    return Scaffold(
      appBar: AppBar(title: Text('Pokemons')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final pokemon = viewModel.pokemons[index];

          return SizedBox(
            height: 120,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pokemon.name, style: titleStyle),
                    const Spacer(),
                    SvgPicture.network(pokemon.imageUrl, width: 150),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: viewModel.pokemons.length,
      ),
    );
  }
}
