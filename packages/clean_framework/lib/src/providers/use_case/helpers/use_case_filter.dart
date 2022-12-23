import 'package:clean_framework/src/providers/entity.dart';
import 'package:clean_framework/src/providers/use_case/helpers/input.dart';
import 'package:clean_framework/src/providers/use_case/helpers/output.dart';
import 'package:meta/meta.dart';

part 'input_filter_map.dart';
part 'output_filter_map.dart';

abstract class UseCaseFilter<E extends Entity> {}

abstract class OutputFilter<E extends Entity, O extends Output>
    implements UseCaseFilter<E> {
  const OutputFilter() : _transformer = null;

  factory OutputFilter.from(O Function(E) transformer) = _OutputFilter<E, O>;

  const OutputFilter._(this._transformer);

  final O Function(E)? _transformer;

  MapEntry<Type, OutputBuilder<E>> get _entry => MapEntry(O, transform);

  @protected
  O transform(E entity);
}

abstract class InputFilter<E extends Entity, I extends Input>
    implements UseCaseFilter<E> {
  const InputFilter() : _transformer = null;

  factory InputFilter.from(E Function(E, I) transformer) = _InputFilter<E, I>;

  const InputFilter._(this._transformer);

  final E Function(E, I)? _transformer;

  MapEntry<Type, InputProcessor<E>> get _entry {
    return MapEntry(I, (i, e) => transform(e, i as I));
  }

  @protected
  E transform(E entity, I input);
}

class _OutputFilter<E extends Entity, O extends Output>
    extends OutputFilter<E, O> {
  const _OutputFilter(super.transformer) : super._();

  @override
  O transform(E entity) => _transformer!(entity);
}

class _InputFilter<E extends Entity, I extends Input>
    extends InputFilter<E, I> {
  const _InputFilter(super.transformer) : super._();

  @override
  E transform(E entity, I input) => _transformer!(entity, input);
}
