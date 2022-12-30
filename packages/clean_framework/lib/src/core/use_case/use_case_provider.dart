import 'dart:async';

import 'package:clean_framework/src/core/clean_framework_provider.dart';
import 'package:clean_framework/src/core/use_case/use_case.dart';
import 'package:clean_framework/src/providers/entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

class UseCaseProvider<E extends Entity, U extends UseCase<E>>
    extends CleanFrameworkProvider<StateNotifierProvider<U, E>> {
  UseCaseProvider(U Function() create)
      : super(provider: StateNotifierProvider((_) => create()));

  Future<AlwaysAliveRefreshable<U>> get notifier => _initCompleter.future;

  void init() {
    if (!_initCompleter.isCompleted) {
      _initCompleter.complete(call().notifier);
    }
  }

  final Completer<AlwaysAliveRefreshable<U>> _initCompleter = Completer();

  O subscribe<O extends Output>(WidgetRef ref) {
    return ref.watch(_listenForOutputChange(ref));
  }

  U getUseCase(WidgetRef ref) => ref.read(call().notifier);

  void listen<O extends Output>(WidgetRef ref, void Function(O?, O) listener) {
    ref.listen<O>(_listenForOutputChange(ref), listener);
  }

  AlwaysAliveProviderListenable<O> _listenForOutputChange<O extends Output>(
    WidgetRef ref,
  ) {
    final useCase = getUseCase(ref);
    return call().select((e) => useCase.getOutput());
  }

  @visibleForTesting
  U read(ProviderContainer container) => container.read(call().notifier);
}
