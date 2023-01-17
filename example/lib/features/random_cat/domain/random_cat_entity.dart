import 'package:clean_framework/clean_framework_legacy.dart';

class RandomCatEntity extends Entity {
  RandomCatEntity({
    this.isLoading = false,
    this.id = 0,
    this.url = '',
  });

  final bool isLoading;
  final int id;
  final String url;

  @override
  List<Object?> get props => [isLoading, id, url];

  RandomCatEntity merge({
    bool? isLoading,
    int? id,
    String? url,
  }) {
    return RandomCatEntity(
      isLoading: isLoading ?? this.isLoading,
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }
}
