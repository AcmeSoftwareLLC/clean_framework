import 'package:clean_framework/clean_framework_providers.dart';

class FirebaseSuccessResponse extends SuccessResponse {
  final Map<String, dynamic> json;
  const FirebaseSuccessResponse(this.json);
}

abstract class FirebaseFailureResponse extends FailureResponse {}

class NoContentFirebaseFailureResponse extends FirebaseFailureResponse {}

class WriteFirebaseFailureResponse extends FirebaseFailureResponse {}
