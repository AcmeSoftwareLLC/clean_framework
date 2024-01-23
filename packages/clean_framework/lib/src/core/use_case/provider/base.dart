part of 'use_case_provider.dart';

abstract class UseCaseProviderBase<E extends Entity, U extends UseCase<E>> {
  final StreamController<Refreshable<U>> _notifierController =
      StreamController.broadcast();

  Stream<Refreshable<U>> get notifier => _notifierController.stream;

  Override overrideWith(U useCase);

  @visibleForOverriding
  Refreshable<U> buildNotifier();

  void init() => _notifierController.add(buildNotifier());

  M subscribe<M extends DomainModel>(WidgetRef ref) {
    return ref.watch(_outputChangeListener(ref));
  }

  U getUseCase(WidgetRef ref) {
    return ref.read(buildNotifier());
  }

  U getUseCaseFromContext(BuildContext context) {
    return read(AppProviderScope.containerOf(context));
  }

  void listen<M extends DomainModel>(
    WidgetRef ref,
    void Function(M?, M) listener,
  ) {
    ref.listen<M>(_outputChangeListener(ref), listener);
  }

  ProviderListenable<M> _outputChangeListener<M extends DomainModel>(
    WidgetRef ref,
  ) {
    return selector(getUseCase(ref));
  }

  ProviderListenable<M> selector<M extends DomainModel>(U useCase);

  @visibleForTesting
  U read(ProviderContainer container) {
    return container.read(buildNotifier());
  }
}
