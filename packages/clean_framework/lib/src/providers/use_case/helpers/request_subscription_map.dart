import 'dart:async';

import 'package:clean_framework/src/providers/use_case/helpers/input.dart';
import 'package:clean_framework/src/providers/use_case/helpers/output.dart';
import 'package:either_dart/either.dart';

typedef RequestSubscriptionMap<I extends Input>
    = Map<Type, RequestSubscription<I>>;

typedef Result<I extends Input> = FutureOr<Either<FailureInput, I>>;

typedef RequestSubscription<I extends Input> = Result<I> Function(dynamic);

extension RequestSubscriptionMapExtension<I extends Input>
    on RequestSubscriptionMap<I> {
  void add<O extends Output>(RequestSubscription<I> subscription) {
    if (this[O] != null) {
      throw StateError('A subscription for $O already exists');
    }

    this[O] = subscription;
  }

  Result<S> call<O extends Output, S extends SuccessInput>(
    O output,
  ) async {
    final subscription = this[O];

    if (subscription == null) {
      return Left<NoSubscriptionFailureInput, S>(
        NoSubscriptionFailureInput<O>(),
      );
    }

    final result = await subscription(output);
    return result as Either<FailureInput, S>;
  }
}
