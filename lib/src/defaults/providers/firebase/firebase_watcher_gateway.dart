import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework/clean_framework_providers.dart';

import 'firebase_requests.dart';
import 'firebase_responses.dart';

abstract class FirebaseWatcherGateway<
    O extends Output,
    R extends FirebaseRequest,
    P extends FirebaseSuccessResponse,
    S extends SuccessInput> extends WatcherGateway<O, R, P, S> {
  FirebaseWatcherGateway(
      {required ProvidersContext context, required UseCaseProvider provider})
      : super(context: context, provider: provider);
}
