import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_domain_models.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example_rest/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example_rest/providers.dart';
import 'package:flutter/material.dart';

class ProfilePresenter extends Presenter<ProfileViewModel,
    ProfileDomainToUIModel, ProfileUseCase> {
  ProfilePresenter({
    required super.builder,
    required String name,
  }) : super.family(family: profileUseCaseFamily, arg: name);

  @protected
  void onLayoutReady(BuildContext context, ProfileUseCase useCase) {
    useCase.fetchPokemonProfile();
  }

  @override
  ProfileViewModel createViewModel(
    ProfileUseCase useCase,
    ProfileDomainToUIModel domainModel,
  ) {
    return ProfileViewModel(
      pokemonTypes:
          domainModel.types.map(PokemonType.new).toList(growable: false),
      description: domainModel.description,
      height: '📏 ${domainModel.height} m',
      weight: '⚖️ ${domainModel.weight} kg',
      stats: domainModel.stats,
    );
  }
}
