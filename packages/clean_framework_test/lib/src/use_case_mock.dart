import 'package:clean_framework/clean_framework.dart';
import 'package:mocktail/mocktail.dart';

class UseCaseMock<E extends Entity> extends Mock {
  UseCaseMock({
    required this.entity,
    List<UseCaseTransformer<E>>? transformers,
  }) {
    if (transformers != null && transformers.isNotEmpty) {
      _domainModelFilters.addTransformers(transformers);
    }
  }

  final E entity;
  final DomainModelFilterMap<E> _domainModelFilters = {};

  M getDomainModel<M extends DomainModel>() => _domainModelFilters<M>(entity);
}
