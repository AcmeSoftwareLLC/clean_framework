import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:flutter/material.dart';

class ProfilePresenter
    extends Presenter<ProfileViewModel, ProfileUIOutput, ProfileUseCase> {
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
    ProfileUIOutput output,
  ) {
    return ProfileViewModel(
      pokemonTypes: output.types.map(PokemonType.new).toList(growable: false),
      description: output.description,
      height: '📏 ${output.height} m',
      weight: '⚖️ ${output.weight} kg',
      stats: output.stats,
    );
  }
}
