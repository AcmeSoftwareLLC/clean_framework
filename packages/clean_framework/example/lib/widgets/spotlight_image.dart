import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';

class SpotlightImage extends StatefulWidget {
  const SpotlightImage({
    super.key,
    required this.cacheKey,
    required this.heroTag,
    this.placeholderBuilder,
    this.width,
    this.height,
  });

  final String cacheKey;
  final String heroTag;
  final WidgetBuilder? placeholderBuilder;
  final double? width;
  final double? height;

  @override
  State<SpotlightImage> createState() => _SpotlightImageState();
}

class _SpotlightImageState extends State<SpotlightImage> {
  PaletteGenerator? _palette;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFileFromCache(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 0.8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: SweepGradient(
                  center: FractionalOffset.center,
                  colors: [
                    _getColor((p) => p.dominantColor),
                    _getColor((p) => p.vibrantColor),
                    _getColor((p) => p.mutedColor),
                    _getColor((p) => p.lightMutedColor),
                    _getColor((p) => p.dominantColor),
                  ],
                  stops: <double>[0.0, 0.2, 0.5, 0.7, 1.0],
                  transform: GradientRotation(pi * 1.5),
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      for (var a = 0; a < 200; a++) Colors.black.withAlpha(a),
                    ],
                    stops: [
                      for (var stop = 0.0; stop < 1.0; stop += 1 / 200) stop
                    ],
                    radius: pi / 4,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Hero(
                      tag: widget.heroTag,
                      child: SvgPicture.string(
                        snapshot.data!,
                        placeholderBuilder: widget.placeholderBuilder,
                        height: widget.height,
                        width: widget.width,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return SizedBox(height: widget.height, width: widget.width);
      },
    );
  }

  Future<String> _loadFileFromCache() async {
    final file = await DefaultCacheManager().getSingleFile(
      '',
      key: widget.cacheKey,
    );
    final rawSvg = await file.readAsString();

    if (rawSvg.isNotEmpty) {
      final drawable = await svg.fromSvgString(rawSvg, widget.cacheKey);
      final picture = drawable.toPicture();
      final image = await picture.toImage(100, 100);
      _palette = await PaletteGenerator.fromImage(image);
    }

    return rawSvg;
  }

  Color _getColor(PaletteColor? Function(PaletteGenerator) generator) {
    const fallbackColor = Colors.white;

    if (_palette == null) return fallbackColor;
    return generator(_palette!)?.color ?? fallbackColor;
  }
}
