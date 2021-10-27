import 'package:clean_framework/clean_framework_providers.dart';

abstract class FirebaseRequest extends Request {
  final String path;

  FirebaseRequest({required this.path});

  Map<String, dynamic> toJson() => {};
}

abstract class FirebaseWatchAllRequest extends FirebaseRequest {
  FirebaseWatchAllRequest({required String path}) : super(path: path);
}

abstract class FirebaseWatchIdRequest extends FirebaseRequest {
  final String id;
  FirebaseWatchIdRequest({required String path, required this.id})
      : super(path: path);
}

abstract class FirebaseReadAllRequest extends FirebaseRequest {
  FirebaseReadAllRequest({required String path}) : super(path: path);
}

abstract class FirebaseReadIdRequest extends FirebaseRequest {
  final String id;
  FirebaseReadIdRequest({required String path, required this.id})
      : super(path: path);
}

abstract class FirebaseWriteRequest extends FirebaseRequest {
  final String id;
  FirebaseWriteRequest({required String path, required this.id})
      : super(path: path);
}

abstract class FirebaseUpdateRequest extends FirebaseRequest {
  final String id;
  FirebaseUpdateRequest({required String path, required this.id})
      : super(path: path);
}

abstract class FirebaseDeleteRequest extends FirebaseRequest {
  final String id;
  FirebaseDeleteRequest({required String path, required this.id})
      : super(path: path);
}
