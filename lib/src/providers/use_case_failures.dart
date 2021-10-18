import 'package:equatable/equatable.dart';

class UseCaseFailure extends Equatable {
  const UseCaseFailure();

  @override
  List<Object?> get props => [];
}

class GeneralUseCaseFailure extends UseCaseFailure {
  const GeneralUseCaseFailure();
}

class NoConnectivityUseCaseFailure extends UseCaseFailure {
  const NoConnectivityUseCaseFailure();
}
