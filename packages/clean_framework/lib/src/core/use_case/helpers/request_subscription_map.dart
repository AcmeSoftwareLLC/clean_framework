import 'dart:async';

import 'package:clean_framework/src/core/use_case/helpers/domain_input.dart';
import 'package:clean_framework/src/core/use_case/helpers/domain_model.dart';
import 'package:clean_framework/src/utilities/either.dart';

typedef RequestSubscriptionMap<I extends DomainInput>
    = Map<Type, RequestSubscription<DomainModel, I>>;

typedef Result<I extends DomainInput> = FutureOr<Either<FailureDomainInput, I>>;

typedef RequestSubscription<M extends DomainModel, I extends DomainInput>
    = Result<I> Function(M);

extension RequestSubscriptionMapExtension<I extends DomainInput>
    on RequestSubscriptionMap<I> {
  void add<M extends DomainModel>(RequestSubscription<M, I> subscription) {
    this[M] = (domainModel) => subscription(domainModel as M);
  }

  Result<S> getDomainInput<S extends SuccessDomainInput>(
    DomainModel domainModel,
  ) async {
    final domainModelType = domainModel.runtimeType;
    final subscription = this[domainModelType];

    if (subscription == null) {
      throw StateError(
        '\n\nNo subscription for "$domainModelType" exists.\n\n'
        'Please follow the steps below in order to fix this issue:\n'
        '1. Ensure that the use case that requests "$domainModelType" is '
        'attached to the appropriate gateway.\n'
        '     AppropriateGatewayProvider(\n'
        '       ...,\n'
        '       useCases: [<<useCaseProvider>>],\n'
        '     )\n'
        '2. Ensure that the gateway that belongs to "$domainModelType" is '
        'attached to the appropriate external interface.\n'
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

    final result = await subscription(domainModel);
    return result as Either<FailureDomainInput, S>;
  }
}
