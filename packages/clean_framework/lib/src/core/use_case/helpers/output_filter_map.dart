part of 'use_case_transformer.dart';

typedef OutputBuilder<E extends Entity> = DomainModel Function(E);

typedef OutputFilterMap<E extends Entity> = Map<Type, OutputBuilder<E>>;

extension OutputFilterMapExtension<E extends Entity> on OutputFilterMap<E> {
  M call<M extends DomainModel>(E entity) {
    final builder = this[M];

    if (builder == null) {
      throw StateError(
        '\n\nOutput filter not defined for "$M".\n'
        'Filters available for: ${keys.isEmpty ? 'none' : keys.join(', ')}\n'
        'Dependency: $E\n\n',
      );
    }

    return builder(entity) as M;
  }

  void addTransformers(List<UseCaseTransformer> transformers) {
    addEntries(
      transformers
          .whereType<DomainModelTransformer<E, DomainModel>>()
          .map((f) => f._entry),
    );
  }
}
