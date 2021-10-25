import 'package:clean_framework/clean_framework_providers.dart';

class FirebaseRequest extends Request {
  final String path;

  FirebaseRequest({required this.path});

  Map<String, dynamic> toJson() => {};
}

class FirebaseWatchAllRequest extends FirebaseRequest {
  FirebaseWatchAllRequest({required String path}) : super(path: path);
}

class FirebaseWatchIdRequest extends FirebaseRequest {
  final String id;
  FirebaseWatchIdRequest({required String path, required this.id})
      : super(path: path);
}

class FirebaseReadAllRequest extends FirebaseRequest {
  FirebaseReadAllRequest({required String path}) : super(path: path);
}

class FirebaseReadIdRequest extends FirebaseRequest {
  final String id;
  FirebaseReadIdRequest({required String path, required this.id})
      : super(path: path);
}

class FirebaseWriteRequest extends FirebaseRequest {
  final String id;
  FirebaseWriteRequest({required String path, required this.id})
      : super(path: path);
}

class FirebaseUpdateRequest extends FirebaseRequest {
  final String id;
  FirebaseUpdateRequest({required String path, required this.id})
      : super(path: path);
}

class FirebaseDeleteRequest extends FirebaseRequest {
  final String id;
  FirebaseDeleteRequest({required String path, required this.id})
      : super(path: path);
}
