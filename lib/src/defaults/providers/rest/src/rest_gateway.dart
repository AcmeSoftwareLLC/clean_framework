import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_requests.dart';
import 'package:clean_framework/src/defaults/providers/rest/src/rest_responses.dart';

abstract class RestGateway<O extends Output, R extends RestRequest,
    S extends SuccessInput> extends Gateway<O, R, RestSuccessResponse, S> {
  RestGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);
}
