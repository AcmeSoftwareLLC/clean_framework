import 'package:clean_framework/src/core/use_case/helpers/input.dart';
import 'package:clean_framework/src/core/use_case/helpers/output.dart';
import 'package:clean_framework/src/core/use_case/use_case_state.dart';
import 'package:meta/meta.dart';

part 'input_filter_map.dart';
part 'output_filter_map.dart';

abstract class UseCaseTransformer<E extends UseCaseState> {}

abstract class OutputTransformer<E extends UseCaseState, O extends DomainOutput>
    implements UseCaseTransformer<E> {
  const OutputTransformer() : _transformer = null;

  factory OutputTransformer.from(O Function(E) transformer) =
      _OutputFilter<E, O>;

  const OutputTransformer._(this._transformer);

  final O Function(E)? _transformer;

  MapEntry<Type, OutputBuilder<E>> get _entry => MapEntry(O, transform);

  @protected
  O transform(E entity);
}

abstract class DomainInputTransformer<E extends UseCaseState,
    I extends DomainInput> implements UseCaseTransformer<E> {
  const DomainInputTransformer() : _transformer = null;

  factory DomainInputTransformer.from(E Function(E, I) transformer) =
      _InputFilter<E, I>;

  const DomainInputTransformer._(this._transformer);

  final E Function(E, I)? _transformer;

  MapEntry<Type, InputProcessor<E>> get _entry {
    return MapEntry(I, (i, e) => transform(e, i as I));
  }

  @protected
  E transform(E entity, I input);
}

class _OutputFilter<E extends UseCaseState, O extends DomainOutput>
    extends OutputTransformer<E, O> {
  const _OutputFilter(super.transformer) : super._();

  @override
  O transform(E entity) => _transformer!(entity);
}

class _InputFilter<E extends UseCaseState, I extends DomainInput>
    extends DomainInputTransformer<E, I> {
  const _InputFilter(super.transformer) : super._();

  @override
  E transform(E entity, I input) => _transformer!(entity, input);
}
