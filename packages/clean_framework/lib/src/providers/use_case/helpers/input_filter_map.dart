part of 'use_case_filter.dart';

typedef InputProcessor<E extends Entity> = E Function(dynamic, E);

typedef InputFilterMap<E extends Entity> = Map<Type, InputProcessor<E>>;

extension InputFilterMapExtension<E extends Entity> on InputFilterMap<E> {
  E call<I extends Input>(E entity, I input) {
    final processor = this[I];

    if (processor == null) {
      throw StateError('Input processor not defined for $I');
    }

    return processor(input, entity);
  }

  void addFilters(List<UseCaseFilter> filters) {
    addEntries(
      filters.whereType<InputFilter<E, Input>>().map((f) => f._entry),
    );
  }
}
