part of 'use_case_transformer.dart';

typedef OutputBuilder<E extends Entity> = Output Function(E);

typedef OutputFilterMap<E extends Entity> = Map<Type, OutputBuilder<E>>;

extension OutputFilterMapExtension<E extends Entity> on OutputFilterMap<E> {
  O call<O extends Output>(E entity) {
    final builder = this[O];

    if (builder == null) {
      throw StateError(
        'Output filter not defined for "$O".\n'
        'Filters available for: ${keys.isEmpty ? 'none' : keys.join(', ')}\n'
        'Dependency: $E',
      );
    }

    return builder(entity) as O;
  }

  void addTransformers(List<UseCaseTransformer> transformers) {
    addEntries(
      transformers
          .whereType<OutputTransformer<E, Output>>()
          .map((f) => f._entry),
    );
  }
}
