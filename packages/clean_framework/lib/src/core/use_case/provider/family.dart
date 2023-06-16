part of 'use_case_provider.dart';

class UseCaseProviderFamily<E extends Entity, U extends UseCase<E>,
    A extends Object> {
  UseCaseProviderFamily(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    _internal = StateNotifierProviderFamily(
      (ref, arg) {
        final useCase = create(arg);
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
    );
  }

  late final StateNotifierProviderFamily<U, E, A> _internal;

  UseCaseProvider<E, U> call(A arg) => UseCaseProvider._(_internal(arg));
}

class UseCaseProviderFamilyBuilder {
  const UseCaseProviderFamilyBuilder();

  UseCaseProviderFamily<E, U, A>
      call<E extends Entity, U extends UseCase<E>, A extends Object>(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return UseCaseProviderFamily(create, connector);
  }
}

class AutoDisposeUseCaseProviderFamily<E extends Entity, U extends UseCase<E>,
    A extends Object> {
  AutoDisposeUseCaseProviderFamily(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    _internal = AutoDisposeStateNotifierProviderFamily(
      (ref, arg) {
        final useCase = create(arg);
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
    );
  }

  late final AutoDisposeStateNotifierProviderFamily<U, E, A> _internal;

  AutoDisposeUseCaseProvider<E, U> call(A arg) {
    return AutoDisposeUseCaseProvider._(_internal(arg));
  }
}

class AutoDisposeUseCaseProviderFamilyBuilder {
  const AutoDisposeUseCaseProviderFamilyBuilder();

  AutoDisposeUseCaseProviderFamily<E, U, A>
      call<E extends Entity, U extends UseCase<E>, A extends Object>(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return AutoDisposeUseCaseProviderFamily(create, connector);
  }
}
