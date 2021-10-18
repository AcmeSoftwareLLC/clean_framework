import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExternalInterfaceProvider<I extends ExternalInterface>
    implements OverridableProvider<I> {
  final Provider<I> _provider;
  final I Function(ProviderRefBase) create;

  ExternalInterfaceProvider(this.create) : _provider = Provider<I>(create);

  @override
  Override overrideWith(I interface) => _provider.overrideWithValue(interface);

  I getExternalInterface(ProvidersContext context) => context().read(_provider);
}
