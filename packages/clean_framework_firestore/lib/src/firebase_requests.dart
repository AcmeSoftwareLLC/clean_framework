import 'package:clean_framework/clean_framework.dart';

class FirebaseRequest extends Request {
  const FirebaseRequest({required this.path});
  final String path;

  Map<String, dynamic> toJson() => {};
}

class FirebaseWatchAllRequest extends FirebaseRequest {
  const FirebaseWatchAllRequest({required super.path});
}

class FirebaseWatchIdRequest extends FirebaseRequest {
  const FirebaseWatchIdRequest({required super.path, required this.id});
  final String id;
}

class FirebaseReadAllRequest extends FirebaseRequest {
  const FirebaseReadAllRequest({required super.path});
}

class FirebaseReadIdRequest extends FirebaseRequest {
  const FirebaseReadIdRequest({required super.path, required this.id});
  final String id;
}

class FirebaseWriteRequest extends FirebaseRequest {
  const FirebaseWriteRequest({
    required super.path,
    this.id,
    this.merge = false,
  });
  final String? id;
  final bool merge;
}

class FirebaseUpdateRequest extends FirebaseRequest {
  const FirebaseUpdateRequest({required super.path, required this.id});
  final String id;
}

class FirebaseDeleteRequest extends FirebaseRequest {
  const FirebaseDeleteRequest({required super.path, required this.id});
  final String id;
}
