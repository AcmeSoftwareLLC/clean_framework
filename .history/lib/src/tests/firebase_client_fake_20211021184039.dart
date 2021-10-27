import 'dart:async';

import 'package:clean_framework/src/defaults/providers/firebase/firebase_client.dart';

class FirebaseClientFake implements FirebaseClient {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  final _content = {'content': ''};
  FirebaseClientFake();

  @override
  Future<void> delete(
      {required String path, required String id, BatchKey? batchKey}) async {
    _content['content'] = 'deleted';
  }

  @override
  Future<Map<String, dynamic>> read(
      {required String path, required String id}) async {
    if (_content['content']!.isEmpty) _content['content'] = 'from read id';
    return _content;
  }

  @override
  Future<Map<String, dynamic>> readAll({required String path}) async {
    if (_content['content']!.isEmpty) _content['content'] = 'from read all';
    return _content;
  }

  @override
  Future<void> update(
      {required String path,
      required Map<String, dynamic> content,
      required String id,
      BatchKey? batchKey}) async {
    content['content'] = 'updated';
  }

  @override
  Stream<Map<String, dynamic>> watch(
      {required String path, required String id}) {
    if (_content['content']!.isEmpty) _content['content'] = _content['content']! + ' from watch id';
    Future.delayed(
        Duration(milliseconds: 100), () => _controller.sink.add(_content));
    return _controller.stream;
  }

  @override
  Stream<Map<String, dynamic>> watchAll({required String path}) {
    if (_content['content']!.isEmpty) _content['content'] = _content['content']! + ' from watch all';
    Future.delayed(
        Duration(milliseconds: 100), () => _controller.sink.add(_content));
    return _controller.stream;
  }

  @override
  Future<String> write(
      {required String path,
      required Map<String, dynamic> content,
      String? id,
      BatchKey? batchKey}) async {
    content['content'] = content;
    return 'id';
  }

  @override
  void createQuery(String path, SnapshotQuery<Map<String, dynamic>> query) =>
      _content['content'] = _content['content']! + ' with query';

  @override
  clearQuery() => _query = null;

  void dispose() {
    _controller.close();
  }
}
