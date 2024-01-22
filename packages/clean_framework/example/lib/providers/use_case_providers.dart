import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_example/features/form/domain/form_state.dart';
import 'package:clean_framework_example/features/form/domain/form_use_case.dart';
import 'package:clean_framework_example/features/home/domain/home_state.dart';
import 'package:clean_framework_example/features/home/domain/home_use_case.dart';
import 'package:clean_framework_example/features/profile/domain/profile_state.dart';
import 'package:clean_framework_example/features/profile/domain/profile_use_case.dart';

final homeUseCaseProvider = UseCaseProvider.autoDispose<HomeState, HomeUseCase>(
  HomeUseCase.new,
  (bridge) {
    bridge.connect(
      formUseCaseProvider,
      selector: (e) => e.userMeta.email,
      (oldEmail, email) {
        if (oldEmail != email) {
          bridge.useCase.setInput(LoggedInEmailDomainInput(email: email));
        }
      },
    );
  },
);

final profileUseCaseFamily =
    UseCaseProvider.family<ProfileState, ProfileUseCase, String>(
  ProfileUseCase.new,
);

final formUseCaseProvider = UseCaseProvider<FormState, FormUseCase>(
  FormUseCase.new,
);
