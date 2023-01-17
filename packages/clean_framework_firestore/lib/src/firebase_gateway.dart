import 'package:clean_framework/clean_framework_legacy.dart';

import 'package:clean_framework_firestore/src/firebase_requests.dart';
import 'package:clean_framework_firestore/src/firebase_responses.dart';

abstract class FirebaseGateway<O extends Output, R extends FirebaseRequest,
    S extends SuccessInput> extends Gateway<O, R, FirebaseSuccessResponse, S> {
  FirebaseGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }
}
