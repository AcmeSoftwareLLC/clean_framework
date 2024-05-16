import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example_rest/widgets/spotlight.dart';
import 'package:flutter/material.dart';

class ProfileUI extends UI<ProfileViewModel> {
  ProfileUI({
    required this.pokemonName,
    required this.pokemonImageUrl,
  });

  final String pokemonName;
  final String pokemonImageUrl;

  @override
  ProfilePresenter create(WidgetBuilder builder) {
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
      body: Consumer(
        builder: (context, ref, child) {
          return Spotlight(
            height: 200,
            heroTag: pokemonName,
            imageUrl: pokemonImageUrl,
            builder: (_) => child!,
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: Theme.of(context).brightness == Brightness.light ? 0 : 4,
          color: Theme.of(context).colorScheme.surface.withAlpha(120),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 96, 24, 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: viewModel.pokemonTypes
                        .map(_PokeTypeChip.new)
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 24),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      viewModel.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _BodyMeasurement(
                    height: viewModel.height,
                    weight: viewModel.weight,
                  ),
                  const SizedBox(height: 32),
                  _ProfileStats(stats: viewModel.stats),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileStats extends StatelessWidget {
  const _ProfileStats({required this.stats});

  final List<PokemonStat> stats;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final stat in stats)
          Padding(
            padding: const EdgeInsets.all(6),
            child: _StatRow(stat: stat),
          ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.stat});

  final PokemonStat stat;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final primaryColor = themeData.colorScheme.primary;
    final pointFraction = stat.point / 255;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  stat.name,
                  style: themeData.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                stat.point.toString(),
                style: themeData.textTheme.titleSmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              color: primaryColor.withAlpha(stat.point),
              value: pointFraction,
              minHeight: 8,
              backgroundColor: themeData.colorScheme.surfaceVariant,
            ),
          ),
        ),
      ],
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
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: type.color,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
