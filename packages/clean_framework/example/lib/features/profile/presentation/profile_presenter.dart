import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';
import 'package:clean_framework_example/features/profile/presentation/profile_view_model.dart';
import 'package:clean_framework_example/providers.dart';

class ProfilePresenter
    extends Presenter<ProfileViewModel, ProfileUIOutput, ProfileUseCase> {
  ProfilePresenter({
    required super.builder,
  }) : super(provider: profileUseCaseProvider);

  @override
  ProfileViewModel createViewModel(
    ProfileUseCase useCase,
    ProfileUIOutput output,
  ) {
    return ProfileViewModel();
  }
}
