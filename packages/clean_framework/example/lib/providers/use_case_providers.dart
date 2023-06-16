import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';

final homeUseCaseProvider = UseCaseProvider.autoDispose(
  HomeUseCase.new,
  (bridge) {
    // bridge.connect(
    //   profileUseCaseProvider,
    //   selector: (e) => e.name,
    //   (oldPokeName, pokeName) {
    //     if (oldPokeName != pokeName) {
    //       bridge.useCase.setInput(LastViewedPokemonInput(name: pokeName));
    //     }
    //   },
    // );
  },
);

final profileUseCaseProviderFamily =
    UseCaseProvider.family<ProfileEntity, ProfileUseCase, String>(
  ProfileUseCase.new,
);

final formUseCaseProvider = UseCaseProvider(FormUseCase.new);
