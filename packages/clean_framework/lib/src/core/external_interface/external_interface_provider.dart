import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:clean_framework/src/core/external_interface/external_interface.dart';
import 'package:clean_framework/src/core/gateway/gateway_provider.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

class ExternalInterfaceProvider<E extends ExternalInterface>
    extends CleanFrameworkProvider<Provider<E>> {
  ExternalInterfaceProvider(
    E Function() create, {
    List<GatewayProvider> gateways = const [],
  }) : super(
          provider: Provider(
            (ref) => create()..attach(ref, providers: gateways),
          ),
        );

  Override overrideWith(E interface) => call().overrideWithValue(interface);

  @visibleForTesting
  E read(ProviderContainer container) => container.read(call());

  void initializeFor(ProviderContainer container) => read(container);
}
