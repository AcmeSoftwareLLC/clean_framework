part of 'use_case_provider.dart';

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
      provider._internal.select(selector),
      connector,
      fireImmediately: fireImmediately,
    );
  }
}
