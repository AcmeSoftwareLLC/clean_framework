import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

class ExternalInterfaceProvider<I extends ExternalInterface>
    implements OverridableProvider<I> {
  ExternalInterfaceProvider(this.create) : _provider = Provider<I>(create);
  final Provider<I> _provider;
  final I Function(Ref) create;

  @override
  Override overrideWith(I interface) => _provider.overrideWithValue(interface);

  I getExternalInterface(ProvidersContext context) => context().read(_provider);
}
