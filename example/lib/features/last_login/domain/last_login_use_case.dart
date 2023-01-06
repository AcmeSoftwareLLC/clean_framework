import 'package:clean_framework/clean_framework_legacy.dart';
import 'last_login_entity.dart';

class LastLoginUseCase extends UseCase<LastLoginEntity> {
  LastLoginUseCase()
      : super(
          entity: LastLoginEntity(),
          transformers: [
            OutputTransformer.from(
              (entity) => LastLoginCTAUIOutput(
                isLoading: entity.state == LastLoginState.loading,
              ),
            ),
            LastLoginUIOutputTransformer(),
          ],
        );

  Future<void> fetchCurrentDate() async {
    entity = entity.merge(state: LastLoginState.loading);

    await request(
      LastLoginDateOutput(),
      onSuccess: (LastLoginDateInput input) {
        return entity.merge(
          state: LastLoginState.idle,
          lastLogin: input.lastLogin,
        );
      },
      onFailure: (_) => entity,
    );
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

class LastLoginDateInput extends SuccessInput {
  final DateTime lastLogin;

  LastLoginDateInput(this.lastLogin);
}

class LastLoginUIOutputTransformer
    extends OutputTransformer<LastLoginEntity, LastLoginUIOutput> {
  @override
  LastLoginUIOutput transform(LastLoginEntity entity) {
    return LastLoginUIOutput(lastLogin: entity.lastLogin);
  }
}
