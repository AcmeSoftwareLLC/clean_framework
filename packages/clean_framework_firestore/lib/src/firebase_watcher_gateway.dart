import 'package:clean_framework/clean_framework_providers.dart';

import 'package:clean_framework_firestore/src/firebase_requests.dart';
import 'package:clean_framework_firestore/src/firebase_responses.dart';

abstract class FirebaseWatcherGateway<
    O extends Output,
    R extends FirebaseRequest,
    P extends FirebaseSuccessResponse,
    S extends SuccessInput> extends WatcherGateway<O, R, P, S> {
  FirebaseWatcherGateway({
    required super.context,
    required super.provider,
  });
}
