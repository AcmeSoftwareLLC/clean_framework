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
        '\n\nNo subscription for "$O" exists.\n'
        'Please ensure that the gateway that belongs to "$O" is attached '
        'the appropriate external interface.\n'
        'Also, ensure that the associated external interface is initialized.\n'
        '\nExternal Interfaces can be initialized '
        'by either calling initializeFor() in its provider, or by adding '
        'the provider to AppProviderScope.\n',
      );
    }

    final result = await subscription(output);
    return result as Either<FailureInput, S>;
  }
}
