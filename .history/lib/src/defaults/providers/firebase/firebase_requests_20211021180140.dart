import 'package:clean_framework/clean_framework_providers.dart';

class FirebaseRequest extends Request {
  final String path;

  FirebaseRequest({required this.path});

  Map<String, dynamic> toJson() => {};

  List<Object?> get props => [path];
}

class FirebaseWatchAllRequest extends FirebaseRequest {
  FirebaseWatchAllRequest({required String path}) : super(path: path);

  List<Object?> get props => [path];
}

class FirebaseWatchIdRequest extends FirebaseRequest {
  final String id;
  FirebaseWatchIdRequest({required String path, required this.id})
      : super(path: path);
  @override
  List<Object?> get props => [path, id];
}

class FirebaseReadAllRequest extends FirebaseRequest {
  FirebaseReadAllRequest({required String path}) : super(path: path);

  List<Object?> get props => [path];
}

class FirebaseReadIdRequest extends FirebaseRequest {
  final String id;
  FirebaseReadIdRequest({required String path, required this.id})
      : super(path: path);

  List<Object?> get props => [path, id];
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
