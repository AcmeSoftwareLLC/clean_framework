import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

class DependencyProvider<T extends Object>
    extends CleanFrameworkProvider<Provider<T>> {
  DependencyProvider(T Function(DependencyRef) create)
      : super(
          provider: Provider((ref) => create(DependencyRef(ref))),
        );

  Override overrideWith(T dependency) => call().overrideWithValue(dependency);

  @visibleForTesting
  T read(ProviderContainer container) => container.read(call());
}

class DependencyRef {
  const DependencyRef(this._ref);

  final Ref _ref;

  T read<T extends Object>(DependencyProvider<T> provider) {
    return _ref.read(provider());
  }
}
