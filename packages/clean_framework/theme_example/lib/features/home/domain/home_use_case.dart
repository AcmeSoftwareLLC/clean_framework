import 'package:clean_framework/clean_framework.dart';
import 'package:theme_example/features/home/domain/home_domain_models.dart';
import 'package:theme_example/features/home/domain/home_entity.dart';

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: const HomeEntity(),
          transformers: [
            HomeDomainToUIModelTransformer(),
            HomeThemeDomainToUIModelTransformer(),
          ],
        );

  Future<void> getTheme() async {
    entity = entity.copyWith(
      appTheme: AppTheme.light,
    );
  }

  Future<void> updateTheme(AppTheme? theme) async {
    entity = entity.copyWith(
      appTheme: theme,
    );
  }
}

class HomeDomainToUIModelTransformer
    extends DomainModelTransformer<HomeEntity, HomeDomainToUIModel> {
  @override
  HomeDomainToUIModel transform(HomeEntity entity) {
    return HomeDomainToUIModel(
      appTheme: entity.appTheme,
    );
  }
}

class HomeThemeDomainToUIModelTransformer
    extends DomainModelTransformer<HomeEntity, HomeThemeDomainToUIModel> {
  @override
  HomeThemeDomainToUIModel transform(HomeEntity entity) {
    return HomeThemeDomainToUIModel(
      appTheme: entity.appTheme,
    );
  }
}
