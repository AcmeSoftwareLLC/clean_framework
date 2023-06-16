part of 'use_case_provider.dart';

abstract class UseCaseProviderBase<E extends Entity, U extends UseCase<E>> {
  final StreamController<Refreshable<U>> _notifierController =
      StreamController.broadcast();

  Stream<Refreshable<U>> get notifier => _notifierController.stream;

  Override overrideWith(U useCase);

  @visibleForOverriding
  Refreshable<U> buildNotifier(Object arg);

  void init({Object args = const Object()}) {
    _notifierController.add(buildNotifier(args));
  }

  O subscribe<O extends Output>(WidgetRef ref) {
    return ref.watch(_outputChangeListener(ref));
  }

  U getUseCase(WidgetRef ref, {Object args = const Object()}) {
    return ref.read(buildNotifier(args));
  }

  U getUseCaseFromContext(BuildContext context) {
    return read(AppProviderScope.containerOf(context));
  }

  void listen<O extends Output>(WidgetRef ref, void Function(O?, O) listener) {
    ref.listen<O>(_outputChangeListener(ref), listener);
  }

  ProviderListenable<O> _outputChangeListener<O extends Output>(WidgetRef ref) {
    return selector(getUseCase(ref));
  }

  ProviderListenable<O> selector<O extends Output>(U useCase);

  @visibleForTesting
  U read(ProviderContainer container, {Object args = const Object()}) {
    return container.read(buildNotifier(args));
  }
}
