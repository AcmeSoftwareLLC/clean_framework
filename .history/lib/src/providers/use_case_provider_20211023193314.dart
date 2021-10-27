import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    implements OverridableProvider<U> {
  final StateNotifierProvider<U, E> _provider;
  final U Function(ProviderRefBase) create;

  UseCaseProvider(this.create)
      : _provider = StateNotifierProvider<U, E>(create);

  @override
  Override overrideWith(U useCase) => _provider.overrideWithValue(useCase);

  U getUseCase(WidgetRef ref) => ref.watch(_provider.notifier);

  U getUseCaseFromContext(ProvidersContext context) {
    return context().read(_provider.notifier);
  }

  O subscribe<O extends Output>(WidgetRef ref) {
    final useCase = getUseCase(ref);
    return ref.watch(_provider.select((e) => useCase.getOutput()));
  }

  void listen<O extends Output>(
      ProvidersContext context, OutputListener<O> listener) {
    final useCase = context().read(_provider.notifier);

    context().listen<E>(_provider.select((E e) => useCase.getOutput()),
        (E e) => listener(useCase.getOutput<O>()));
  }
}

typedef ProviderListener<E extends Entity> = void Function(E entity);

typedef OutputListener<O extends Output> = void Function(O output);
