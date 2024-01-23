import 'package:clean_framework/clean_framework_legacy.dart';

import 'package:clean_framework_firestore/src/firebase_requests.dart';
import 'package:clean_framework_firestore/src/firebase_responses.dart';

abstract class FirebaseGateway<M extends DomainModel, R extends FirebaseRequest,
        S extends SuccessDomainInput>
    extends Gateway<M, R, FirebaseSuccessResponse, S> {
  FirebaseGateway({
    required ProvidersContext context,
    required UseCaseProvider provider,
  }) : super(context: context, provider: provider);

  @override
  FailureDomainInput onFailure(FailureResponse failureResponse) {
    return FailureDomainInput(message: failureResponse.message);
  }
}
