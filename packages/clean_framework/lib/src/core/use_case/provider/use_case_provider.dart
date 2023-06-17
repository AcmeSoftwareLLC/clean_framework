import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

part 'auto_dispose.dart';
part 'base.dart';
part 'bridge.dart';
part 'family.dart';

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    extends UseCaseProviderBase<E, U> {
  UseCaseProvider(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    _internal = StateNotifierProvider(
      (ref) {
        final useCase = create();
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
    );
  }

  UseCaseProvider._(this._internal);

  late final StateNotifierProvider<U, E> _internal;

  static const autoDispose = AutoDisposeUseCaseProviderBuilder();

  static const family = UseCaseProviderFamilyBuilder();

  @override
  Refreshable<U> buildNotifier() => _internal.notifier;

  @override
  Override overrideWith(U useCase) => _internal.overrideWith((_) => useCase);

  @override
  ProviderListenable<O> selector<O extends Output>(U useCase) {
    return _internal.select((_) => useCase.getOutput());
  }

  StateNotifierProvider<U, E> call() => _internal;
}
