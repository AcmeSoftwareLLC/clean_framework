import 'dart:convert';

import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:flutter/services.dart';

class AssetFeatureProvider extends JsonFeatureProvider {
  Future<void> load(String key) async {
    final rawFlags = await rootBundle.loadString(key);

    feed(jsonDecode(rawFlags));
  }
}
