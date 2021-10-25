import 'package:clean_framework/clean_framework_providers.dart';
import 'package:flutter/foundation.dart';

class LastLoginISOViewModel extends ViewModel {
  final String isoDate;

  LastLoginISOViewModel({
    required this.isoDate,
  });

  @override
  List<Object?> get props => [isoDate];
}

class LastLoginShortViewModel extends ViewModel {
  final String shortDate;

  LastLoginShortViewModel({
    required this.shortDate,
  });

  @override
  List<Object?> get props => [shortDate];
}

class LastLoginCTAViewModel extends ViewModel {
  final bool isLoading;
  final VoidCallback fetchCurrentDate;

  LastLoginCTAViewModel({
    required this.isLoading,
    required this.fetchCurrentDate,
  });

  @override
  List<Object?> get props => [];
}
