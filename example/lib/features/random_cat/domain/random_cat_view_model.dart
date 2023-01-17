import 'package:clean_framework/clean_framework_legacy.dart';

class RandomCatViewModel extends ViewModel {
  RandomCatViewModel({
    required this.isLoading,
    required this.id,
    required this.url,
    required this.fetch,
  });

  final bool isLoading;
  final int id;
  final String url;

  final Future<void> Function() fetch;

  @override
  List<Object?> get props => [isLoading, id, url];
}
