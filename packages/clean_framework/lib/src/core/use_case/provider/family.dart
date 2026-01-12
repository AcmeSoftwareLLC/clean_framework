part of 'use_case_provider.dart';

abstract class UseCaseProviderFamilyBase<E extends Entity, U extends UseCase<E>, A extends Object> {
  // ignore: close_sinks
  final StreamController<(Refreshable<U>, A)> _notifierController = StreamController.broadcast();

  Stream<(Refreshable<U>, A)> get notifier => _notifierController.stream;

  void init(A arg);

  UseCaseProviderBase<E, U> call(A arg);
}

class UseCaseProviderFamily<E extends Entity, U extends UseCase<E>, A extends Object>
    extends UseCaseProviderFamilyBase<E, U, A> {
  UseCaseProviderFamily(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    //ignore: invalid_use_of_internal_member
    _internal = StateNotifierProviderFamily(
      (ref, arg) {
        final useCase = create(arg);
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
    );
  }

  late final StateNotifierProviderFamily<U, E, A> _internal;

  @override
  void init(A arg) => _notifierController.add((_internal(arg).notifier, arg));

  @override
  UseCaseProvider<E, U> call(A arg) => UseCaseProvider._(_internal(arg));
}

class UseCaseProviderFamilyBuilder {
  const UseCaseProviderFamilyBuilder();

  UseCaseProviderFamily<E, U, A> call<E extends Entity, U extends UseCase<E>, A extends Object>(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return UseCaseProviderFamily(create, connector);
  }
}

class AutoDisposeUseCaseProviderFamily<E extends Entity, U extends UseCase<E>, A extends Object>
    extends UseCaseProviderFamilyBase<E, U, A> {
  AutoDisposeUseCaseProviderFamily(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    _internal = StateNotifierProvider.family<U, E, A>(
      (ref, arg) {
        final useCase = create(arg);
        connector?.call(UseCaseProviderBridge._(useCase, ref));
        return useCase;
      },
      isAutoDispose: true,
    );
  }

  late final StateNotifierProviderFamily<U, E, A> _internal;

  @override
  void init(A arg) => _notifierController.add((_internal(arg).notifier, arg));

  @override
  AutoDisposeUseCaseProvider<E, U> call(A arg) {
    return AutoDisposeUseCaseProvider._(_internal(arg));
  }
}

class AutoDisposeUseCaseProviderFamilyBuilder {
  const AutoDisposeUseCaseProviderFamilyBuilder();

  AutoDisposeUseCaseProviderFamily<E, U, A> call<E extends Entity, U extends UseCase<E>, A extends Object>(
    U Function(A) create, [
    UseCaseProviderConnector<E, U>? connector,
  ]) {
    return AutoDisposeUseCaseProviderFamily(create, connector);
  }
}
