import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    implements OverridableProvider<U> {
  final StateNotifierProvider<U, E> _provider;
  final U Function(Ref) create;

  UseCaseProvider(this.create)
      : _provider = StateNotifierProvider<U, E>(create);

  @override
  Override overrideWith(U useCase) => _provider.overrideWithValue(useCase);

  U getUseCase(WidgetRef ref) => ref.watch(_provider.notifier);

  U getUseCaseFromContext(ProvidersContext context) {
    return context().read(_provider.notifier);
  }

  O subscribe<O extends Output>(WidgetRef ref) {
    return ref.watch(_listenForOutputChange(ref));
  }

  void listen<O extends Output>(WidgetRef ref, void Function(O?, O) listener) {
    ref.listen<O>(_listenForOutputChange(ref), listener);
  }

  AlwaysAliveProviderListenable<O> _listenForOutputChange<O extends Output>(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return _provider.select((e) => useCase.getOutput());
  }
}

typedef ProviderListener<E extends Entity> = void Function(E entity);
