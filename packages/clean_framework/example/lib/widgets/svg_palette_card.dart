import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SvgPaletteCard extends StatefulWidget {
  const SvgPaletteCard({
    super.key,
    required this.url,
    required this.builder,
    this.duration = const Duration(milliseconds: 500),
    this.placeholderBuilder,
    this.width,
    this.height,
  });

  final String url;
  final Widget Function(BuildContext, SvgPicture) builder;
  final Duration duration;
  final WidgetBuilder? placeholderBuilder;
  final double? width;
  final double? height;

  @override
  State<SvgPaletteCard> createState() => _SvgPaletteCardState();
}

class _SvgPaletteCardState extends State<SvgPaletteCard> {
  Color? _color;
  String _rawSvg = '';

  @override
  void initState() {
    super.initState();
    _generateColor();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _color,
      child: AnimatedSwitcher(
        duration: widget.duration,
        child: _rawSvg.isEmpty
            ? _buildPlaceHolder(context)
            : widget.builder(
                context,
                SvgPicture.string(
                  _rawSvg,
                  placeholderBuilder: widget.placeholderBuilder,
                  height: widget.height,
                  width: widget.width,
                ),
              ),
      ),
    );
  }

  Future<void> _generateColor() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(widget.url);
      _rawSvg = await file.readAsString();

      if (mounted) setState(() {});

      if (_rawSvg.isNotEmpty) {
        final drawable = await svg.fromSvgString(_rawSvg, widget.url);
        final picture = drawable.toPicture();
        final image = await picture.toImage(100, 100);
        final palette = await PaletteGenerator.fromImage(image);

        _color = palette.vibrantColor?.color;

        if (mounted) setState(() {});
      }
    } catch (e) {
      log(e.toString(), name: 'SvgPaletteCard');
    }
  }

  Widget _buildPlaceHolder(BuildContext context) {
    return widget.placeholderBuilder?.call(context) ??
        SizedBox(height: widget.height, width: widget.width);
  }
}
