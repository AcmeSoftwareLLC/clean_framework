import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_legacy.dart';
import 'package:clean_framework/src/providers/overridable_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/misc.dart';

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    implements OverridableProvider<U> {
  UseCaseProvider(this.create)
      : _provider = StateNotifierProvider<U, E>(create);
  final StateNotifierProvider<U, E> _provider;
  final U Function(Ref) create;

  @override
  Override overrideWith(U useCase) => _provider.overrideWith((_) => useCase);

  U getUseCase(WidgetRef ref) => ref.watch(_provider.notifier);

  U getUseCaseFromContext(ProvidersContext context) {
    return context().read(_provider.notifier);
  }

  M subscribe<M extends DomainModel>(WidgetRef ref) {
    return ref.watch(_listenForOutputChange(ref));
  }

  void listen<M extends DomainModel>(
    WidgetRef ref,
    void Function(M?, M) listener,
  ) {
    ref.listen<M>(_listenForOutputChange(ref), listener);
  }

  ProviderListenable<M> _listenForOutputChange<M extends DomainModel>(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return _provider.select((e) => useCase.getDomainModel());
  }
}

typedef ProviderListener<E extends Entity> = void Function(E entity);
