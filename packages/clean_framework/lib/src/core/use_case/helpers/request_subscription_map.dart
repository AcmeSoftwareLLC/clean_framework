import 'dart:async';

import 'package:clean_framework/src/core/use_case/helpers/input.dart';
import 'package:clean_framework/src/core/use_case/helpers/output.dart';
import 'package:clean_framework/src/utilities/either.dart';

typedef RequestSubscriptionMap<I extends Input>
    = Map<Type, RequestSubscription<Output, I>>;

typedef Result<I extends Input> = FutureOr<Either<FailureInput, I>>;

typedef RequestSubscription<O extends Output, I extends Input> = Result<I>
    Function(O);

extension RequestSubscriptionMapExtension<I extends Input>
    on RequestSubscriptionMap<I> {
  void add<O extends Output>(RequestSubscription<O, I> subscription) {
    this[O] = (output) => subscription(output as O);
  }

  Result<S> call<S extends SuccessInput>(Output output) async {
    final outputType = output.runtimeType;
    final subscription = this[outputType];

    if (subscription == null) {
      throw StateError(
        '\n\nNo subscription for "$outputType" exists.\n\n'
        'Please follow the steps below in order to fix this issue:\n'
        '1. Ensure that the use case that requests "$outputType" is attached '
        'the appropriate gateway.\n'
        '     AppropriateGatewayProvider(\n'
        '       ...,\n'
        '       useCases: [<<useCaseProvider>>],\n'
        '     )\n'
        '2. Ensure that the gateway that belongs to "$outputType" is attached '
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
