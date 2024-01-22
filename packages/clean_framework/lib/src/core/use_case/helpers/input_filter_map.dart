part of 'use_case_transformer.dart';

typedef InputProcessor<E extends UseCaseState> = E Function(dynamic, E);

typedef InputFilterMap<E extends UseCaseState> = Map<Type, InputProcessor<E>>;

extension InputFilterMapExtension<E extends UseCaseState> on InputFilterMap<E> {
  E call<I extends DomainInput>(E entity, I input) {
    final processor = this[I];

    if (processor == null) {
      throw StateError(
        '\n\nInput filter not defined for "$I".\n'
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
