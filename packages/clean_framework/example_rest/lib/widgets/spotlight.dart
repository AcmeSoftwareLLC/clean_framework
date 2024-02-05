import 'dart:math';

import 'package:clean_framework_example_rest/widgets/app_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';

class Spotlight extends StatefulWidget {
  const Spotlight({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    required this.builder,
    this.placeholderBuilder,
    this.width,
    this.height,
  });

  final String imageUrl;
  final String heroTag;
  final WidgetBuilder builder;
  final WidgetBuilder? placeholderBuilder;
  final double? width;
  final double? height;

  @override
  State<Spotlight> createState() => _SpotlightState();
}

class _SpotlightState extends State<Spotlight> {
  PaletteGenerator? _palette;
  String? _rawSvg;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadFileFromCache();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (_rawSvg != null) {
      return Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            height: size.height,
            width: size.width,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
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
                    center: FractionalOffset(0.5, 0.3),
                    colors: [
                      for (var a = 0; a < 200; a++)
                        Theme.of(context).colorScheme.background.withAlpha(a),
                    ],
                    stops: [
                      for (var stop = 0.0; stop < 1.0; stop += 1 / 200) stop
                    ],
                    radius: size.width / 600,
                  ),
                ),
                child: const SizedBox(),
              ),
            ),
          ),
          Positioned.fill(
            top: size.height / 3,
            child: widget.builder(context),
          ),
          Positioned(
            top: size.height / 7,
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Hero(
                  tag: widget.heroTag,
                  child: SvgPicture.string(
                    _rawSvg!,
                    placeholderBuilder: widget.placeholderBuilder,
                    height: widget.height,
                    width: widget.width,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(height: widget.height, width: widget.width);
  }

  Future<void> _loadFileFromCache() async {
    final cacheManager = AppScope.cacheManagerOf(context);
    final file = await cacheManager.getSingleFile(widget.imageUrl);

    _rawSvg = await file.readAsString();
    if (mounted) setState(() {});

    if (_rawSvg!.isNotEmpty) {
      final pictureInfo = await vg.loadPicture(SvgStringLoader(_rawSvg!), null);
      final image = await pictureInfo.picture.toImage(100, 100);

      _palette = await AppScope.paletteGeneratorOf(context, image);
      if (mounted) setState(() {});
    }
  }

  Color _getColor(PaletteColor? Function(PaletteGenerator) generator) {
    const fallbackColor = Colors.white;

    if (_palette == null) return fallbackColor;
    return generator(_palette!)?.color ?? fallbackColor;
  }
}
