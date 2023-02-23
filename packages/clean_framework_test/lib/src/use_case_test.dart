// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_test/src/diff.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:meta/meta.dart';

@isTest
ProviderContainer
    useCaseTest<U extends UseCase<E>, E extends Entity, O extends Output>(
  String description, {
  required UseCaseProviderBase provider,
  required FutureOr<void> Function(U) execute,
  dynamic Function()? expect,
  FutureOr<void> Function(U)? verify,
  E Function(E)? seed,
}) {
  final container = ProviderContainer();

  ft.test(
    description,
    () async {
      final useCase = provider.read(container) as U;

      if (seed != null) {
        useCase.entity = seed(useCase.entity);
      }

      final outputs = <O>[];

      final completer = Completer<void>();
      final subscription = useCase.stream
          .map((e) => useCase.transformToOutput<O>(e))
          .listen(outputs.add, onDone: completer.complete);

      await execute(useCase);
      await completer.future;

      if (expect != null) {
        final dynamic expected = expect();
        final shallowEquality = '$outputs' == '$expected';

        try {
          ft.expect(outputs, ft.wrapMatcher(expected));
        } on ft.TestFailure catch (e) {
          if (shallowEquality || expected is! List<O>) rethrow;
          final difference = diff(expected: expected, actual: outputs);
          throw ft.TestFailure('${e.message}\n$difference');
        }
      }

      await subscription.cancel();
      await verify?.call(useCase);
    },
  );

  return container;
}

@isTest
ProviderContainer useCaseBridgeTest<TU extends UseCase<E>, E extends Entity,
    O extends Output, FU extends UseCase>(
  String description, {
  required UseCaseProviderBase from,
  required UseCaseProviderBase to,
  required FutureOr<void> Function(FU) execute,
  Iterable<dynamic> Function()? expect,
  FutureOr<void> Function(TU)? verify,
  E Function(E)? seed,
}) {
  final container = ProviderContainer();

  ft.test(
    description,
    () async {
      final fromUseCase = from.read(container) as FU;
      final toUseCase = to.read(container) as TU;

      if (seed != null) {
        toUseCase.entity = seed(toUseCase.entity);
      }

      final outputs = <O>[];

      final completer = Completer<void>();
      final subscription = toUseCase.stream
          .map((e) => toUseCase.transformToOutput<O>(e))
          .listen(outputs.add, onDone: completer.complete);

      await execute(fromUseCase);
      await completer.future;

      if (expect != null) {
        final dynamic expected = expect();
        final shallowEquality = '$outputs' == '$expected';

        try {
          ft.expect(outputs, ft.wrapMatcher(expected));
        } on ft.TestFailure catch (e) {
          if (shallowEquality || expected is! List<O>) rethrow;
          final difference = diff(expected: expected, actual: outputs);
          throw ft.TestFailure('${e.message}\n$difference');
        }
      }

      await subscription.cancel();
      await verify?.call(toUseCase);
    },
  );

  return container;
}
