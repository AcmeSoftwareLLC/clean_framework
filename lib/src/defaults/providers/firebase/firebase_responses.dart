import 'package:clean_framework/clean_framework_providers.dart';

class FirebaseSuccessResponse extends SuccessResponse {
  final Map<String, dynamic> json;
  const FirebaseSuccessResponse(this.json);

  @override
  List<Object?> get props => [json];
}

class FirebaseFailureResponse
    extends TypedFailureResponse<FirebaseFailureType> {
  FirebaseFailureResponse({
    required FirebaseFailureType type,
    String message = '',
    Map<String, Object?> errorData = const {},
  }) : super(type: type, message: message, errorData: errorData);
}

enum FirebaseFailureType { noContent }
