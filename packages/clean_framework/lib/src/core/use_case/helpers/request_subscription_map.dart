import 'dart:async';

import 'package:clean_framework/src/core/use_case/helpers/input.dart';
import 'package:clean_framework/src/core/use_case/helpers/output.dart';
import 'package:clean_framework/src/utilities/either.dart';

typedef RequestSubscriptionMap<I extends Input>
    = Map<Type, RequestSubscription<I>>;

typedef Result<I extends Input> = FutureOr<Either<FailureInput, I>>;

typedef RequestSubscription<I extends Input> = Result<I> Function(dynamic);

extension RequestSubscriptionMapExtension<I extends Input>
    on RequestSubscriptionMap<I> {
  void add<O extends Output>(RequestSubscription<I> subscription) {
    if (this[O] != null) {
      throw StateError('A subscription for $O already exists.');
    }

    this[O] = subscription;
  }

  Result<S> call<O extends Output, S extends SuccessInput>(
    O output,
  ) async {
    final subscription = this[O];

    if (subscription == null) {
      throw StateError(
        '\n\nNo subscription for "$O" exists.\n\n'
        'Please follow the steps below in order to fix this issue:\n'
        '1. Ensure that the use case that requests "$O" is attached '
        'the appropriate gateway.\n'
        '     AppropriateGatewayProvider(\n'
        '       ...,\n'
        '       useCases: [<<useCaseProvider>>],\n'
        '     )\n'
        '2. Ensure that the gateway that belongs to "$O" is attached '
        'the appropriate external interface.\n'
        '     AppropriateExternalInterfaceProvider(\n'
        '       ...,\n'
        '       gateways: [<<gatewayProvider>>],\n'
        '     )\n'
        '3. Ensure that the associated external interface is initialized.\n'
        '     AppProviderScope(\n'
        '       ...,\n'
        '       externalInterfaceProviders: [\n'
        '         <<associatedExternalInterfaceProvider>>,\n'
        '       ],\n'
        '     )\n',
      );
    }

    final result = await subscription(output);
    return result as Either<FailureInput, S>;
  }
}
