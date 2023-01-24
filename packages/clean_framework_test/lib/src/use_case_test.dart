// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: invalid_use_of_protected_member

import 'dart:async';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

@isTest
ProviderContainer
    useCaseTest<U extends UseCase<E>, E extends Entity, O extends Output>(
  String description, {
  required UseCaseProviderBase provider,
  required FutureOr<void> Function(U) execute,
  Iterable<dynamic> Function()? expect,
  FutureOr<void> Function(U)? verify,
  E Function(E)? seed,
}) {
  final container = ProviderContainer();

  test(
    description,
    () async {
      final useCase = provider.read(container) as U;

      if (seed != null) {
        useCase.entity = seed(useCase.entity);
      }

      Future<void>? expectation;
      if (expect != null) {
        expectation = expectLater(
          useCase.stream.map((e) => useCase.transformToOutput<O>(e)),
          emitsInOrder(expect()),
        );
      }

      await execute(useCase);
      await expectation;

      await verify?.call(useCase);
    },
  );

  return container;
}
