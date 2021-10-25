import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework_example/features/last_login/domain/last_login_use_case.dart';
import 'package:clean_framework_example/providers.dart';
import 'package:intl/intl.dart';

import 'last_login_view_model.dart';

class LastLoginIsoDatePresenter extends Presenter<LastLoginISOViewModel,
    LastLoginUIOutput, LastLoginUseCase> {
  LastLoginIsoDatePresenter(
      {required PresenterBuilder<LastLoginISOViewModel> builder})
      : super(
          provider: lastLoginUseCaseProvider,
          builder: builder,
        );

  @override
  LastLoginISOViewModel createViewModel(
      LastLoginUseCase useCase, LastLoginUIOutput output) {
    return LastLoginISOViewModel(
      isoDate: DateFormat.yMMMMd('en_US').format(output.lastLogin),
    );
  }
}

class LastLoginShortDatePresenter extends Presenter<LastLoginShortViewModel,
    LastLoginUIOutput, LastLoginUseCase> {
  LastLoginShortDatePresenter(
      {required PresenterBuilder<LastLoginShortViewModel> builder})
      : super(
          provider: lastLoginUseCaseProvider,
          builder: builder,
        );

  @override
  LastLoginShortViewModel createViewModel(
      LastLoginUseCase useCase, LastLoginUIOutput output) {
    return LastLoginShortViewModel(
      shortDate: DateFormat.yMd().format(output.lastLogin),
    );
  }
}

class LastLoginCTAPresenter extends Presenter<LastLoginCTAViewModel,
    LastLoginCTAUIOutput, LastLoginUseCase> {
  LastLoginCTAPresenter({
    required PresenterBuilder<LastLoginCTAViewModel> builder,
    required UseCaseProvider? provider,
  }) : super(
          provider: provider ?? lastLoginUseCaseProvider,
          builder: builder,
        );

  @override
  LastLoginCTAViewModel createViewModel(
      LastLoginUseCase useCase, LastLoginCTAUIOutput output) {
    return LastLoginCTAViewModel(
      isLoading: output.isLoading,
      fetchCurrentDate: () => useCase.fetchCurrentDate(),
    );
  }
}
