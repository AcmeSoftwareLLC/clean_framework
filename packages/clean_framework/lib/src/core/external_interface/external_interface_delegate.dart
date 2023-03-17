part of 'external_interface.dart';

abstract class ExternalInterfaceDelegate {
  ExternalInterface? _externalInterface;

  // ignore: use_setters_to_change_properties
  @protected
  @nonVirtual
  void attachTo(ExternalInterface externalInterface) {
    _externalInterface = externalInterface;
  }

  /// Locates dependency from the [provider].

  @nonVirtual
  T locate<T extends Object>(DependencyProvider<T> provider) {
    final ref = _externalInterface?._ref;
    assert(ref != null, '$runtimeType has not been attached!');
    return ref!.read(provider);
  }
}
