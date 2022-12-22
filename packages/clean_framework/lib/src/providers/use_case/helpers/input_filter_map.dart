import 'package:clean_framework/src/providers/entity.dart';
import 'package:clean_framework/src/providers/use_case/helpers/input.dart';

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
}
