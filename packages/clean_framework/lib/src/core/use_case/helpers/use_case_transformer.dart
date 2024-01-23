import 'package:clean_framework/src/core/use_case/entity.dart';
import 'package:clean_framework/src/core/use_case/helpers/domain_model.dart';
import 'package:clean_framework/src/core/use_case/helpers/domain_input.dart';
import 'package:meta/meta.dart';

part 'input_filter_map.dart';
part 'output_filter_map.dart';

abstract class UseCaseTransformer<E extends Entity> {}

abstract class DomainModelTransformer<E extends Entity, M extends DomainModel>
    implements UseCaseTransformer<E> {
  const DomainModelTransformer() : _transformer = null;

  factory DomainModelTransformer.from(M Function(E) transformer) =
      _DomainModelFilter<E, M>;

  const DomainModelTransformer._(this._transformer);

  final M Function(E)? _transformer;

  MapEntry<Type, OutputBuilder<E>> get _entry => MapEntry(M, transform);

  @protected
  M transform(E entity);
}

abstract class DomainInputTransformer<E extends Entity, I extends DomainInput>
    implements UseCaseTransformer<E> {
  const DomainInputTransformer() : _transformer = null;

  factory DomainInputTransformer.from(E Function(E, I) transformer) =
      _DomainInputFilter<E, I>;

  const DomainInputTransformer._(this._transformer);

  final E Function(E, I)? _transformer;

  MapEntry<Type, InputProcessor<E>> get _entry {
    return MapEntry(I, (i, e) => transform(e, i as I));
  }

  @protected
  E transform(E entity, I input);
}

class _DomainModelFilter<E extends Entity, M extends DomainModel>
    extends DomainModelTransformer<E, M> {
  const _DomainModelFilter(super.transformer) : super._();

  @override
  M transform(E entity) => _transformer!(entity);
}

class _DomainInputFilter<E extends Entity, I extends DomainInput>
    extends DomainInputTransformer<E, I> {
  const _DomainInputFilter(super.transformer) : super._();

  @override
  E transform(E entity, I input) => _transformer!(entity, input);
}
