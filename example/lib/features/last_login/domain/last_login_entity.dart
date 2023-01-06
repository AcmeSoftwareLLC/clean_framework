import 'package:clean_framework/clean_framework_legacy.dart';

class LastLoginEntity extends Entity {
  final DateTime lastLogin;
  final LastLoginState state;

  @override
  List<Object> get props => [lastLogin, state];

  LastLoginEntity({
    LastLoginState? state,
    DateTime? lastLogin,
  })  : state = state ?? LastLoginState.idle,
        lastLogin = lastLogin ?? DateTime.parse('1900-01-01');

  LastLoginEntity merge({
    LastLoginState? state,
    DateTime? lastLogin,
  }) {
    return LastLoginEntity(
      state: state ?? this.state,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}

enum LastLoginState { idle, loading, failure }
