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
    this.cacheKey,
    this.onTap,
    this.placeholderBuilder,
    this.backgroundColorBuilder,
    this.width,
    this.height,
    this.margin = EdgeInsets.zero,
  });

  final String url;
  final Widget Function(BuildContext, SvgPicture) builder;
  final Duration duration;
  final String? cacheKey;
  final VoidCallback? onTap;
  final WidgetBuilder? placeholderBuilder;
  final Color? Function(BuildContext, PaletteGenerator)? backgroundColorBuilder;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry margin;

  @override
  State<SvgPaletteCard> createState() => _SvgPaletteCardState();
}

class _SvgPaletteCardState extends State<SvgPaletteCard> {
  Color? _color;
  String _rawSvg = '';

  @override
  void initState() {
    super.initState();
    _fetchSvg();
  }

  @override
  void didUpdateWidget(SvgPaletteCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _fetchSvg();
    }
    _generateColor();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(12);

    return Card(
      margin: widget.margin,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      color: _color,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: borderRadius,
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
      ),
    );
  }

  Future<void> _fetchSvg() async {
    try {
      final file = await DefaultCacheManager().getSingleFile(
        widget.url,
        key: widget.cacheKey,
      );
      _rawSvg = await file.readAsString();

      if (mounted) setState(() {});

      _generateColor();
    } catch (e) {
      log(e.toString(), name: 'SvgPaletteCard');
    }
  }

  Future<void> _generateColor() async {
    if (_rawSvg.isNotEmpty) {
      final drawable = await svg.fromSvgString(_rawSvg, widget.url);
      final picture = drawable.toPicture();
      final image = await picture.toImage(100, 100);
      final palette = await PaletteGenerator.fromImage(image);

      if (mounted) {
        _color = widget.backgroundColorBuilder?.call(context, palette) ??
            palette.dominantColor?.color;

        setState(() {});
      }
    }
  }

  Widget _buildPlaceHolder(BuildContext context) {
    return widget.placeholderBuilder?.call(context) ??
        SizedBox(height: widget.height, width: widget.width);
  }
}
