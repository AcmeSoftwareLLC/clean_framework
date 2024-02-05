import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_entity.dart';
import 'package:clean_framework_example_rest/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_entity.dart';
import 'package:clean_framework_example_rest/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_entity.dart';
import 'package:clean_framework_example_rest/features/profile/domain/profile_use_case.dart';

final homeUseCaseProvider =
    UseCaseProvider.autoDispose<HomeEntity, HomeUseCase>(
  HomeUseCase.new,
  (bridge) {
    bridge.connect(
      formUseCaseProvider,
      selector: (e) => e.userMeta.email,
      (oldEmail, email) {
        if (oldEmail != email) {
          bridge.useCase.setInput(
            LoggedInEmailDomainInput(email: email),
          );
        }
      },
    );
  },
);

final profileUseCaseFamily =
    UseCaseProvider.family<ProfileEntity, ProfileUseCase, String>(
  ProfileUseCase.new,
);

final formUseCaseProvider = UseCaseProvider<FormEntity, FormUseCase>(
  FormUseCase.new,
);
