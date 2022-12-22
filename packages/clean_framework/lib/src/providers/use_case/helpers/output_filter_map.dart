import 'package:clean_framework/src/providers/entity.dart';
import 'package:clean_framework/src/providers/use_case/helpers/output.dart';

typedef OutputBuilder<E extends Entity> = Output Function(E);

typedef OutputFilterMap<E extends Entity> = Map<Type, OutputBuilder<E>>;

extension OutputFilterMapExtension<E extends Entity> on OutputFilterMap<E> {
  O call<O extends Output>(E entity) {
    final builder = this[O];

    if (builder == null) {
      throw StateError(
        'Output filter not defined for "$O".\n'
        'Filters available for: ${keys.join(', ')}',
      );
    }

    return builder(entity) as O;
  }
}
