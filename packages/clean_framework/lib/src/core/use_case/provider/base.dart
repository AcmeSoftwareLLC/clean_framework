part of 'use_case_provider.dart';

abstract class UseCaseProviderBase<E extends Entity, U extends UseCase<E>> {
  final StreamController<Refreshable<U>> _notifierController =
      StreamController.broadcast();

  Stream<Refreshable<U>> get notifier => _notifierController.stream;

  Override overrideWith(U useCase);

  @visibleForOverriding
  Refreshable<U> buildNotifier();

  void init() => _notifierController.add(buildNotifier());

  O subscribe<O extends DomainOutput>(WidgetRef ref) {
    return ref.watch(_outputChangeListener(ref));
  }

  U getUseCase(WidgetRef ref) {
    return ref.read(buildNotifier());
  }

  U getUseCaseFromContext(BuildContext context) {
    return read(AppProviderScope.containerOf(context));
  }

  void listen<O extends DomainOutput>(
    WidgetRef ref,
    void Function(O?, O) listener,
  ) {
    ref.listen<O>(_outputChangeListener(ref), listener);
  }

  ProviderListenable<O> _outputChangeListener<O extends DomainOutput>(
    WidgetRef ref,
  ) {
    return selector(getUseCase(ref));
  }

  ProviderListenable<O> selector<O extends DomainOutput>(U useCase);

  @visibleForTesting
  U read(ProviderContainer container) {
    return container.read(buildNotifier());
  }
}
