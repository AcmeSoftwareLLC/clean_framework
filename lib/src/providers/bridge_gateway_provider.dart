import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gateway.dart';

class BridgeGatewayProvider<G extends BridgeGateway>
    implements OverridableProvider<G> {
  final Provider<G> _provider;
  final G Function(Ref) create;

  BridgeGatewayProvider(this.create) : _provider = Provider<G>(create);

  @override
  Override overrideWith(G gateway) => _provider.overrideWithValue(gateway);

  G getBridgeGateway(ProvidersContext context) => context().read(_provider);
}
