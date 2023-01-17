import 'dart:async';

import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:clean_framework/src/core/use_case/use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class UseCaseProviderBase<E extends Entity, U extends UseCase<E>,
    N extends ProviderBase<E>> extends CleanFrameworkProvider<N> {
  UseCaseProviderBase({required super.provider});

  final StreamController<Refreshable<U>> _notifierController =
      StreamController.broadcast();

  Stream<Refreshable<U>> get notifier => _notifierController.stream;

  @visibleForOverriding
  Refreshable<U> buildNotifier();

  void init() {
    _notifierController.add(buildNotifier());
  }

  O subscribe<O extends Output>(WidgetRef ref) {
    return ref.watch(_listenForOutputChange(ref));
  }

  U getUseCase(WidgetRef ref) => ref.read(buildNotifier());

  void listen<O extends Output>(WidgetRef ref, void Function(O?, O) listener) {
    ref.listen<O>(_listenForOutputChange(ref), listener);
  }

  ProviderListenable<O> _listenForOutputChange<O extends Output>(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return call().select((e) => useCase.getOutput());
  }

  @visibleForTesting
  U read(ProviderContainer container) => container.read(buildNotifier());
}

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    extends UseCaseProviderBase<E, U, StateNotifierProvider<U, E>> {
  UseCaseProvider(U Function() create)
      : super(provider: StateNotifierProvider((_) => create()));

  static const autoDispose = AutoDisposeUseCaseProviderBuilder();

  @override
  Refreshable<U> buildNotifier() => call().notifier;
}

class AutoDisposeUseCaseProvider<E extends Entity, U extends UseCase<E>>
    extends UseCaseProviderBase<E, U, AutoDisposeStateNotifierProvider<U, E>> {
  AutoDisposeUseCaseProvider(U Function() create)
      : super(provider: StateNotifierProvider.autoDispose((_) => create()));

  @override
  Refreshable<U> buildNotifier() => call().notifier;
}

class AutoDisposeUseCaseProviderBuilder {
  const AutoDisposeUseCaseProviderBuilder();

  AutoDisposeUseCaseProvider<E, U> call<E extends Entity, U extends UseCase<E>>(
    U Function() create,
  ) {
    return AutoDisposeUseCaseProvider(create);
  }
}
