import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/providers/gateway.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BridgeGatewayProvider<G extends BridgeGateway>
    implements OverridableProvider<G> {

  BridgeGatewayProvider(this.create) : _provider = Provider<G>(create);
  final Provider<G> _provider;
  final G Function(Ref) create;

  @override
  Override overrideWith(G gateway) => _provider.overrideWithValue(gateway);

  G getBridgeGateway(ProvidersContext context) => context().read(_provider);
}
