import 'package:clean_framework/clean_framework.dart';
import 'package:mocktail/mocktail.dart';

class UseCaseMock<E extends Entity> extends Mock {
  UseCaseMock({
    required this.entity,
    List<UseCaseTransformer<E>>? transformers,
  }) {
    if (transformers != null && transformers.isNotEmpty) {
      _outputFilters.addTransformers(transformers);
    }
  }

  final E entity;
  final DomainModelFilterMap<E> _outputFilters = {};

  M getOutput<M extends DomainModel>() => _outputFilters<M>(entity);
}
