import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_presenter.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class ProfileUI extends UI<ProfileViewModel> {
  ProfileUI({required this.pokemonName});

  final String pokemonName;

  @override
  ProfilePresenter create(PresenterBuilder<ProfileViewModel> builder) {
    return ProfilePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, ProfileViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(title: Text(pokemonName)),
      body: Hero(
        tag: pokemonName,
        child: CachedImage(
          height: 200,
          cacheKey: pokemonName,
        ),
      ),
    );
  }
}
