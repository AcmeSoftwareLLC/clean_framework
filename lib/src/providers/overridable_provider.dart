import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class OverridableProvider<V extends Object> {
  @visibleForTesting
  Override overrideWith(V value);
}
