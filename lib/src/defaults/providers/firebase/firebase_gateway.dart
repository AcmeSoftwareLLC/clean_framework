import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';

import 'firebase_requests.dart';
import 'firebase_responses.dart';

abstract class FirebaseGateway<O extends Output, R extends FirebaseRequest,
    S extends SuccessInput> extends Gateway<O, R, FirebaseSuccessResponse, S> {
  FirebaseGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);

  @override
  FailureInput onFailure(FailureResponse failureResponse) => FailureInput();
}
