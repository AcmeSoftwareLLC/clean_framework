import 'package:clean_framework/clean_framework_providers.dart';

import 'random_cat_entity.dart';

class RandomCatUseCase extends UseCase<RandomCatEntity> {
  RandomCatUseCase()
      : super(
          entity: RandomCatEntity(),
          transformers: [
            OutputTransformer<RandomCatEntity, RandomCatUIOutput>.from(
              (e) {
                return RandomCatUIOutput(
                  isLoading: e.isLoading,
                  id: e.id,
                  url: e.url,
                );
              },
            ),
          ],
        );

  Future<void> fetch() async {
    return debounce(
      action: () async {
        entity = entity.merge(isLoading: true);

        await request<RandomCatGatewayOutput, RandomCatSuccessInput>(
          RandomCatGatewayOutput(),
          onSuccess: (successInput) => entity.merge(
            isLoading: false,
            id: successInput.id,
            url: successInput.url,
          ),
          onFailure: (failure) => entity.merge(isLoading: false),
        );
      },
      tag: 'fetch',
      duration: const Duration(milliseconds: 500),
      immediate: true,
    );
  }
}

class RandomCatUIOutput extends Output {
  RandomCatUIOutput({
    required this.isLoading,
    required this.id,
    required this.url,
  });

  final bool isLoading;
  final int id;
  final String url;

  @override
  List<Object?> get props => [isLoading, id, url];
}

class RandomCatGatewayOutput extends Output {
  @override
  List<Object?> get props => [];
}

class RandomCatSuccessInput extends SuccessInput {
  final int id;
  final String url;

  RandomCatSuccessInput({
    required this.id,
    required this.url,
  });

  factory RandomCatSuccessInput.fromJson(Map<String, dynamic> json) {
    return RandomCatSuccessInput(
      id: json['id'],
      url: json['webpurl'],
    );
  }
}
