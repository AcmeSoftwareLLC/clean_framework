import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:meta/meta.dart';

part 'auto_dispose.dart';
part 'base.dart';
part 'bridge.dart';
part 'family.dart';

class UseCaseProvider<US extends Entity, U extends UseCase<US>>
    extends UseCaseProviderBase<US, U> {
  UseCaseProvider(
    U Function() create, [
    UseCaseProviderConnector<US, U>? connector,
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

  late final StateNotifierProvider<U, US> _internal;

  static const autoDispose = AutoDisposeUseCaseProviderBuilder();

  static const family = UseCaseProviderFamilyBuilder();

  @override
  Refreshable<U> buildNotifier() => _internal.notifier;

  @override
  Override overrideWith(U useCase) => _internal.overrideWith((_) => useCase);

  @override
  ProviderListenable<M> selector<M extends DomainModel>(U useCase) {
    return _internal.select((_) => useCase.getDomainModel());
  }

  StateNotifierProvider<U, US> call() => _internal;
}
