import 'package:either_dart/either.dart';

import 'gateway.dart';

abstract class ExternalInterface {}

abstract class DirectExternalInterface<R extends Request,
    P extends SuccessResponse> extends ExternalInterface {
  DirectExternalInterface(List<GatewayConnection<Gateway>> gatewayConnections) {
    gatewayConnections.forEach((connection) {
      final gateway = connection();
      gateway.transport = (request) async {
        return onTransport(request as R);
      };
    });
  }

  Future<Either<FailureResponse, SuccessResponse>> onTransport(R request);
}

abstract class WatcherExternalInterface<R extends Request,
    P extends SuccessResponse> extends ExternalInterface {
  WatcherExternalInterface(
      List<GatewayConnection<WatcherGateway>> gatewayConnections) {
    gatewayConnections.forEach((connection) {
      final gateway = connection();
      gateway.transport = (request) async {
        return onTransport(request as R, gateway.yieldResponse);
      };
    });
  }

  Future<Either<FailureResponse, SuccessResponse>> onTransport(
      R request, Function(P) yieldResponse);
}

typedef GatewayConnection<G extends Gateway> = G Function();
