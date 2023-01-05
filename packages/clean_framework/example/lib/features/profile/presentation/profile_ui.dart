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
            elevation: Theme.of(context).brightness == Brightness.light ? 0 : 4,
            color: Theme.of(context).colorScheme.surface.withAlpha(120),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(48),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 88, 24, 16),
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
                  const SizedBox(height: 16),
                  _BodyMeasurement(
                    height: viewModel.height,
                    weight: viewModel.weight,
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

class _BodyMeasurement extends StatelessWidget {
  const _BodyMeasurement({
    required this.height,
    required this.weight,
  });

  final String height;
  final String weight;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final titleStyle = themeData.textTheme.displaySmall!.copyWith(fontSize: 20);
    final subtitleStyle = themeData.textTheme.bodySmall!.copyWith(
      color: themeData.colorScheme.outline,
    );

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(weight, style: titleStyle),
                  const SizedBox(height: 4),
                  Text('Weight', style: subtitleStyle),
                ],
              ),
            ),
            Container(
              width: 1,
              height: 32,
              color: themeData.colorScheme.surfaceVariant,
            ),
            Expanded(
              child: Column(
                children: [
                  Text(height, style: titleStyle),
                  const SizedBox(height: 4),
                  Text('Height', style: subtitleStyle),
                ],
              ),
            ),
          ],
        ),
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
      color: Colors.transparent,
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
