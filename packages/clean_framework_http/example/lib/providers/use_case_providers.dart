import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_http_example/features/home/domain/home_use_case.dart';

final UseCaseProvider<Entity, HomeUseCase> homeUseCaseProvider =
    UseCaseProvider(HomeUseCase.new);
