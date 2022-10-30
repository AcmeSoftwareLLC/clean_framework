import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'gateway.dart';

class GatewayProvider<G extends Gateway> implements OverridableProvider<G> {
  final Provider<G> _provider;
  final G Function(Ref) create;

  GatewayProvider(this.create) : _provider = Provider<G>(create);

  @override
  Override overrideWith(G gateway) => _provider.overrideWithValue(gateway);

  G getGateway(ProvidersContext context) => context().read(_provider);
}
