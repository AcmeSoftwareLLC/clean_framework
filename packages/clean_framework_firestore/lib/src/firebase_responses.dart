import 'package:clean_framework/clean_framework.dart';

class FirebaseSuccessResponse extends SuccessResponse {
  const FirebaseSuccessResponse(this.json);
  final Map<String, dynamic> json;

  @override
  List<Object?> get props => [json];
}

class FirebaseFailureResponse
    extends TypedFailureResponse<FirebaseFailureType> {
  const FirebaseFailureResponse({
    required super.type,
    super.message,
    super.errorData,
  });
}

enum FirebaseFailureType { noContent }
