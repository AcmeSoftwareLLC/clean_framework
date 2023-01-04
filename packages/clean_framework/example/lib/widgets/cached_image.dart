import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.cacheKey,
    this.placeholderBuilder,
    this.width,
    this.height,
  });

  final String cacheKey;
  final WidgetBuilder? placeholderBuilder;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadFileFromCache(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(
            snapshot.data!,
            placeholderBuilder: placeholderBuilder,
            height: height,
            width: width,
          );
        }

        return SizedBox(height: height, width: width);
      },
    );
  }

  Future<String> _loadFileFromCache() async {
    final file = await DefaultCacheManager().getSingleFile('', key: cacheKey);
    return file.readAsString();
  }
}
