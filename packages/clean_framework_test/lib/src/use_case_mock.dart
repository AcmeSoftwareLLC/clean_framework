import 'package:clean_framework/clean_framework.dart';
import 'package:mocktail/mocktail.dart';

class UseCaseMock<E extends UseCaseState> extends Mock {
  UseCaseMock({
    required this.entity,
    List<UseCaseTransformer<E>>? transformers,
  }) {
    if (transformers != null && transformers.isNotEmpty) {
      _outputFilters.addTransformers(transformers);
    }
  }

  final E entity;
  final OutputFilterMap<E> _outputFilters = {};

  O getOutput<O extends DomainOutput>() => _outputFilters<O>(entity);
}
