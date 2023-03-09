import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

abstract class UseCaseProviderBase<E extends Entity, U extends UseCase<E>,
    N extends ProviderBase<E>> extends CleanFrameworkProvider<N> {
  UseCaseProviderBase({required super.provider});

  final StreamController<Refreshable<U>> _notifierController =
      StreamController.broadcast();

  Stream<Refreshable<U>> get notifier => _notifierController.stream;

  Override overrideWith(U useCase);

  @visibleForOverriding
  Refreshable<U> buildNotifier();

  void init() {
    _notifierController.add(buildNotifier());
  }

  O subscribe<O extends Output>(WidgetRef ref) {
    return ref.watch(_listenForOutputChange(ref));
  }

  U getUseCase(WidgetRef ref) => ref.read(buildNotifier());

  U getUseCaseFromContext(BuildContext context) {
    return read(AppProviderScope.containerOf(context));
  }

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
  UseCaseProvider(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) : super(
          provider: StateNotifierProvider(
            (ref) {
              final useCase = create();
              connector?.call(
                UseCaseProviderBridge._(useCase, ref),
              );
              return useCase;
            },
          ),
        );

  static const autoDispose = AutoDisposeUseCaseProviderBuilder();

  @override
  Refreshable<U> buildNotifier() => call().notifier;

  @override
  Override overrideWith(U useCase) => call().overrideWith((_) => useCase);
}

class AutoDisposeUseCaseProvider<E extends Entity, U extends UseCase<E>>
    extends UseCaseProviderBase<E, U, AutoDisposeStateNotifierProvider<U, E>> {
  AutoDisposeUseCaseProvider(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) : super(
          provider: StateNotifierProvider.autoDispose(
            (ref) {
              final useCase = create();
              connector?.call(
                UseCaseProviderBridge._(useCase, ref),
              );
              return useCase;
            },
          ),
        );

  @override
  Refreshable<U> buildNotifier() => call().notifier;

  @override
  Override overrideWith(U useCase) => call().overrideWith((_) => useCase);
}

class AutoDisposeUseCaseProviderBuilder {
  const AutoDisposeUseCaseProviderBuilder();

  AutoDisposeUseCaseProvider<E, U> call<E extends Entity, U extends UseCase<E>>(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return AutoDisposeUseCaseProvider(create, connector);
  }
}

typedef UseCaseProviderConnector<E extends Entity, U extends UseCase<E>> = void
    Function(UseCaseProviderBridge<E, U> bridge);

class UseCaseProviderBridge<BE extends Entity, BU extends UseCase<BE>> {
  UseCaseProviderBridge._(this.useCase, Ref<BE> ref) : _ref = ref;

  final BU useCase;
  final Ref<BE> _ref;

  void connect<E extends Entity, U extends UseCase<E>, T>(
    UseCaseProvider<E, U> provider,
    void Function(T? previous, T next) connector, {
    required T Function(E entity) selector,
    bool fireImmediately = false,
  }) {
    _ref.listen<T>(
      provider().select(selector),
      connector,
      fireImmediately: fireImmediately,
    );
  }
}
