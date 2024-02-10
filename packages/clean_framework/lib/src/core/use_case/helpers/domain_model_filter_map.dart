part of 'use_case_transformer.dart';

typedef DomainModelBuilder<E extends Entity> = DomainModel Function(E);

typedef DomainModelFilterMap<E extends Entity>
    = Map<Type, DomainModelBuilder<E>>;

extension DomainModelFilterMapExtension<E extends Entity>
    on DomainModelFilterMap<E> {
  M call<M extends DomainModel>(E entity) {
    final builder = this[M];

    if (builder == null) {
      throw StateError(
        '\n\nDomain model filter not defined for "$M".\n'
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
