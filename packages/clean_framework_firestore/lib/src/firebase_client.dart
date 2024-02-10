import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseClient([FirebaseFirestore? fireStore])
      : _fireStore = fireStore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _fireStore;
  Query<Map<String, dynamic>>? _queryRef;

  /// Writes using fire-store collection or document depending upon the [path].
  ///
  /// If [id] is provided, a document with the provided id will be created.
  /// Otherwise, an auto-generated id will be provided.
  Future<String> write({
    required String path,
    required Map<String, dynamic> content,
    String? id,
    BatchKey? batchKey,
    bool merge = false,
  }) async {
    if (batchKey != null) {
      batchKey._batch.set(
        _fireStore.collection(path).doc(id),
        content,
      );
      return '';
    }

    if (id == null) {
      final docRef = await _fireStore.collection(path).add(content);
      return docRef.id;
    }
    await _fireStore
        .collection(path)
        .doc(id)
        .set(content, SetOptions(merge: merge));
    return id;
  }

  /// Similar to [write], but updates data in the document.
  Future<void> update({
    required String path,
    required Map<String, dynamic> content,
    required String id,
    BatchKey? batchKey,
  }) async {
    if (batchKey != null) {
      batchKey._batch.update(
        _fireStore.collection(path).doc(id),
        content,
      );
      return;
    }

    return _fireStore.collection(path).doc(id).update(content);
  }

  /// Deletes a document in fire-store.
  Future<void> delete({
    required String path,
    required String id,
    BatchKey? batchKey,
  }) async {
    if (batchKey != null) {
      batchKey._batch.delete(_fireStore.collection(path).doc(id));
      return;
    }

    return _fireStore.collection(path).doc(id).delete();
  }

  /// Queries a fire-store document for the [path] and [id].
  Future<Map<String, dynamic>> read({
    required String path,
    required String id,
  }) async {
    final documentSnapshot = await _fireStore.collection(path).doc(id).get();
    final doc = documentSnapshot.data();

    if (doc == null) return {};

    doc['id'] = documentSnapshot.id;
    return doc;
  }

  void createQuery(String path, SnapshotQuery<Map<String, dynamic>> query) {
    if (_queryRef == null) {
      final ref = _fireStore.collection(path);
      _queryRef = query(ref);
    } else {
      _queryRef = query(_queryRef!);
    }
  }

  void clearQuery() {
    _queryRef = null;
  }

  /// Queries a fire-store collection for the [path].
  Future<Map<String, dynamic>> readAll({
    required String path,
  }) async {
    final ref = _queryRef ?? _fireStore.collection(path);

    final querySnapshots = await ref.get();

    final docs = <Map<String, dynamic>>[];
    for (final snapshot in querySnapshots.docs) {
      final doc = snapshot.data();
      doc['id'] = snapshot.id;
      docs.add(doc);
    }
    return {'list': docs};
  }

  /// Queries a fire-store document for the [path] and [id].
  Stream<Map<String, dynamic>> watch({
    required String path,
    required String id,
  }) async* {
    final docStream = _fireStore.collection(path).doc(id).snapshots();

    await for (final snapshot in docStream) {
      final doc = snapshot.data();
      if (doc != null) {
        doc['id'] = snapshot.id;
        yield doc;
      }
    }
  }

  /// Queries a fire-store collection for the [path].
  Stream<Map<String, dynamic>> watchAll({
    required String path,
  }) async* {
    final ref = _queryRef ?? _fireStore.collection(path);

    await for (final qs in ref.snapshots()) {
      final docs = <Map<String, dynamic>>[];

      for (final snapshot in qs.docs) {
        final doc = snapshot.data();
        doc['id'] = snapshot.id;
        docs.add(doc);
      }
      yield {'list': docs};
    }
  }
}

typedef SnapshotQuery<T> = Query<T> Function(Query<T>);

class BatchKey {
  BatchKey([FirebaseFirestore? fireStore])
      : _batch = (fireStore ?? FirebaseFirestore.instance).batch();

  final WriteBatch _batch;

  Future<void> commit() => _batch.commit();
}
