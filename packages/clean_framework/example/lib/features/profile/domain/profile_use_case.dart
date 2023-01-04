import 'package:clean_framework/clean_framework_core.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_ui_output.dart';

class ProfileUseCase extends UseCase<ProfileEntity> {
  ProfileUseCase()
      : super(
          entity: ProfileEntity(),
          transformers: [
            ProfileUIOutputTransformer(),
          ],
        );
}

class ProfileUIOutputTransformer
    extends OutputTransformer<ProfileEntity, ProfileUIOutput> {
  @override
  ProfileUIOutput transform(ProfileEntity entity) {
    return ProfileUIOutput();
  }
}
