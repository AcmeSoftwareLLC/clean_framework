import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseClient {
  FirebaseClient([FirebaseFirestore? fireStore])
      : _fireStore = fireStore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _fireStore;
  CollectionReference<Map<String, dynamic>>? _queryRef;

  /// Writes using fire-store collection or document depending upon the [path].
  ///
  /// If [id] is provided, a document with the provided id will be created.
  /// Otherwise, an auto-generated id will be provided.
  Future<String> write({
    required String path,
    required Map<String, dynamic> content,
    String? id,
    BatchKey? batchKey,
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
    await _fireStore.collection(path).doc(id).set(content);
    return id;
  }

  /// Similar to [write], but updates data in the document.
  // TODO this process should return something
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

    return await _fireStore.collection(path).doc(id).update(content);
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

    return await _fireStore.doc(path).delete();
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

  void createQuery<T>(String path, SnapshotQuery query) {
    var ref = _fireStore.collection(path);
    _queryRef = query(ref) as CollectionReference<Map<String, dynamic>>;
  }

  void addToQuery(SnapshotQuery query) {
    _queryRef = query(_queryRef) as CollectionReference<Map<String, dynamic>>;
  }

  /// Queries a fire-store collection for the [path].
  Future<Map<String, dynamic>> readAll({
    required String path,
  }) async {
    var ref = (_queryRef != null) ? _queryRef! : _fireStore.collection(path);

    final querySnapshots = await ref.get();

    final _docs = <Map<String, dynamic>>[];
    for (final snapshot in querySnapshots.docs) {
      final doc = snapshot.data();
      doc['id'] = snapshot.id;
      _docs.add(doc);
    }
    return {'list': _docs};
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
    SnapshotQuery? query,
  }) async* {
    var ref = _fireStore.collection(path);
    if (query != null) {
      final queryRef = query(ref);
      if (queryRef is CollectionReference<Map<String, dynamic>>) ref = queryRef;
    }

    await for (final qs in ref.snapshots()) {
      final _docs = <Map<String, dynamic>>[];

      for (final snapshot in qs.docs) {
        final doc = snapshot.data();
        doc['id'] = snapshot.id;
        _docs.add(doc);
      }
      yield {'list': _docs};
    }
  }
}

typedef SnapshotQuery<T> = Query<T> Function(CollectionReference<T>);

class BatchKey {
  WriteBatch _batch;

  BatchKey([FirebaseFirestore? fireStore])
      : _batch = (fireStore ?? FirebaseFirestore.instance).batch();

  Future<void> commit() => _batch.commit();
}
