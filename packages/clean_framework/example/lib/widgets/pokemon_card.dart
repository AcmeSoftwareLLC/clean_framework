import 'package:clean_framework_example/widgets/svg_palette_card.dart';
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
    required this.heroTag,
  });

  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SvgPaletteCard(
      cacheKey: name,
      url: imageUrl,
      onTap: onTap,
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
                child: Hero(tag: heroTag, child: picture),
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
