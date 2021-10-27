import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/clean_framework.dart';
import 'last_login_entity.dart';

class LastLoginUseCase extends UseCase<LastLoginEntity> {
  LastLoginUseCase()
      : super(entity: LastLoginEntity(), outputFilters: {
          LastLoginUIOutput: _lastLoginUIOutput,
          LastLoginCTAUIOutput: _lastLoginCTAUIOutput,
        });

  static LastLoginUIOutput _lastLoginUIOutput(LastLoginEntity entity) =>
      LastLoginUIOutput(
        lastLogin: entity.lastLogin,
      );

  static LastLoginCTAUIOutput _lastLoginCTAUIOutput(LastLoginEntity entity) =>
      LastLoginCTAUIOutput(
        isLoading: entity.state == LastLoginState.loading,
      );

  Future<void> fetchCurrentDate() async {
    entity = entity.merge(state: LastLoginState.loading);

    await request(LastLoginDateOutput(), onSuccess: (LastLoginDateInput input) {
      return entity.merge(
          state: LastLoginState.idle, lastLogin: input.lastLogin);
    }, onFailure: (_) {
      return entity;
    });
  }
}

class LastLoginUIOutput extends Output {
  final DateTime lastLogin;

  LastLoginUIOutput({required this.lastLogin});
  @override
  List<Object?> get props => [lastLogin];
}

class LastLoginCTAUIOutput extends Output {
  final bool isLoading;

  LastLoginCTAUIOutput({required this.isLoading});

  @override
  List<Object?> get props => [isLoading];
}

class LastLoginDateOutput extends Output {
  @override
  List<Object?> get props => [];
}

class LastLoginDateInput extends Equatable {
  final DateTime lastLogin;

  LastLoginDateInput(this.lastLogin);
}
