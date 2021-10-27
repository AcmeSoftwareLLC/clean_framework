import 'package:clean_framework/clean_framework_providers.dart';
import 'package:clean_framework/src/app_providers_container.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_requests.dart';
import 'package:clean_framework/src/defaults/providers/graphql/src/graphql_responses.dart';

abstract class GraphQLGateway<O extends Output, R extends GraphQLRequest,
    S extends SuccessInput> extends Gateway<O, R, GraphQLSuccessResponse, S> {
  GraphQLGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);
}
