import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:clean_framework/src/core/external_interface/external_interface.dart';
import 'package:clean_framework/src/core/gateway/gateway_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

class ExternalInterfaceProvider<E extends ExternalInterface>
    extends CleanFrameworkProvider<Provider<E>> {
  ExternalInterfaceProvider(
    E Function() create, {
    List<GatewayProvider> gateways = const [],
  })  : _gateways = gateways,
        super(
          provider: Provider(
            (ref) => create()..attach(ref, providers: gateways),
          ),
        );

  final List<GatewayProvider> _gateways;

  Override overrideWith(E interface) {
    return call().overrideWith(
      (ref) => interface..attach(ref, providers: _gateways),
    );
  }

  @visibleForTesting
  E read(ProviderContainer container) => container.read(call());

  void initializeFor(ProviderContainer container) => read(container);
}
