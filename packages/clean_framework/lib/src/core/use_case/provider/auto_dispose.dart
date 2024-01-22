part of 'use_case_provider.dart';

class AutoDisposeUseCaseProvider<E extends UseCaseState, U extends UseCase<E>>
    extends UseCaseProviderBase<E, U> {
  AutoDisposeUseCaseProvider(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    _internal = StateNotifierProvider.autoDispose(
      (ref) {
        final useCase = create();
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
    );
  }

  AutoDisposeUseCaseProvider._(this._internal);

  late final AutoDisposeStateNotifierProvider<U, E> _internal;

  @override
  Refreshable<U> buildNotifier() => _internal.notifier;

  @override
  Override overrideWith(U useCase) => _internal.overrideWith((_) => useCase);

  @override
  ProviderListenable<O> selector<O extends DomainOutput>(U useCase) {
    return _internal.select((_) => useCase.getOutput());
  }

  AutoDisposeStateNotifierProvider<U, E> call() => _internal;
}

class AutoDisposeUseCaseProviderBuilder {
  const AutoDisposeUseCaseProviderBuilder();

  AutoDisposeUseCaseProvider<E, U>
      call<E extends UseCaseState, U extends UseCase<E>>(
    U Function() create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return AutoDisposeUseCaseProvider(create, connector);
  }

  AutoDisposeUseCaseProviderFamilyBuilder get family {
    return const AutoDisposeUseCaseProviderFamilyBuilder();
  }
}
