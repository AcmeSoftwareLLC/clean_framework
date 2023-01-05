import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/widgets/spotlight.dart';
import 'package:flutter/material.dart';

class ProfileUI extends UI<ProfileViewModel> {
  ProfileUI({required this.pokemonName});

  final String pokemonName;

  @override
  ProfilePresenter create(PresenterBuilder<ProfileViewModel> builder) {
    return ProfilePresenter(builder: builder, name: pokemonName);
  }

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonName),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Spotlight(
        height: 200,
        heroTag: pokemonName,
        cacheKey: pokemonName,
        builder: (context) {
          final pokeTypes = viewModel.pokemonTypes;

          return Card(
            margin: EdgeInsets.zero,
            elevation: 8,
            color: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 88, 16, 16),
              child: Column(
                children: [
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: pokeTypes.map(_PokeTypeChip.new).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    viewModel.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PokeTypeChip extends StatelessWidget {
  const _PokeTypeChip(this.type);

  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: StadiumBorder(
        side: BorderSide(color: type.color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(type.emoji),
            Text(
              type.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: type.color),
            ),
          ],
        ),
      ),
    );
  }
}
