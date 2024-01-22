import 'package:clean_framework/clean_framework_legacy.dart';

import 'package:clean_framework_firestore/src/firebase_requests.dart';
import 'package:clean_framework_firestore/src/firebase_responses.dart';

abstract class FirebaseWatcherGateway<
    O extends DomainOutput,
    R extends FirebaseRequest,
    P extends FirebaseSuccessResponse,
    S extends SuccessDomainInput> extends WatcherGateway<O, R, P, S> {
  FirebaseWatcherGateway({
    required super.context,
    required super.provider,
  });
}
