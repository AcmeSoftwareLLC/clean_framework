part of '../../use_case.dart';

abstract class UseCaseFilter<E extends Entity> {}

abstract class OutputFilter<E extends Entity, O extends Output>
    implements UseCaseFilter<E> {
  MapEntry<Type, OutputBuilder<E>> get _entry => MapEntry(O, transform);

  @protected
  O transform(E entity);
}

abstract class InputFilter<E extends Entity, I extends Input>
    implements UseCaseFilter<E> {
  MapEntry<Type, InputProcessor<E>> get _entry {
    return MapEntry(I, (i, e) => transform(e, i as I));
  }

  @protected
  E transform(E entity, I input);
}
