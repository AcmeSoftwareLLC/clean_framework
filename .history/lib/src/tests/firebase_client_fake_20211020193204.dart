import 'package:clean_framework/src/defaults/providers/firebase/firebase_client.dart';

class FirebaseClientFake implements FirebaseClient {
  final Map<String, dynamic> content;

  FirebaseClientFake(this.content);

  @override
  Future<void> delete(
      {required String path, required String id, BatchKey? batchKey}) {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> read(
      {required String path, required String id}) async {
    return content;
  }

  @override
  Future<Map<String, dynamic>> readAll(
      {required String path, SnapshotQuery? query}) {
    throw UnimplementedError();
  }

  @override
  Future<void> update(
      {required String path,
      required Map<String, dynamic> content,
      required String id,
      BatchKey? batchKey}) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> watch(
      {required String path, required String id}) {
    throw UnimplementedError();
  }

  @override
  Stream<Map<String, dynamic>> watchAll(
      {required String path, SnapshotQuery? query}) {
    throw UnimplementedError();
  }

  @override
  Future<String> write(
      {required String path,
      required Map<String, dynamic> content,
      String? id,
      BatchKey? batchKey}) {
    throw UnimplementedError();
  }

  @override
  void addToQuery(SnapshotQuery query) {}

  @override
  void createQuery<T>(String path, SnapshotQuery query) {}
}
