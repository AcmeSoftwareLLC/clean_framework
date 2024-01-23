part of 'use_case_transformer.dart';

typedef InputProcessor<E extends Entity> = E Function(dynamic, E);

typedef InputFilterMap<E extends Entity> = Map<Type, InputProcessor<E>>;

extension InputFilterMapExtension<E extends Entity> on InputFilterMap<E> {
  E call<DI extends DomainInput>(E entity, DI input) {
    final processor = this[DI];

    if (processor == null) {
      throw StateError(
        '\n\nInput filter not defined for "$DI".\n'
        'Filters available for: ${keys.isEmpty ? 'none' : keys.join(', ')}\n'
        'Dependency: $E\n\n',
      );
    }

    return processor(input, entity);
  }

  void addTransformers(List<UseCaseTransformer> transformers) {
    addEntries(
      transformers
          .whereType<DomainInputTransformer<E, DomainInput>>()
          .map((f) => f._entry),
    );
  }
}
