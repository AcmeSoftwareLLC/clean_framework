import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FireStore {
  FireStore([FirebaseFirestore? fireStore])
      : _fireStore = fireStore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _fireStore;

  /// Writes using fire-store collection or document depending upon the [path].
  ///
  /// If [id] is provided, a document with the provided id will be created.
  /// Otherwise, an auto-generated id will be provided.
  Future<String?> write({
    required String path,
    required StoreModel model,
    String? id,
    BatchKey? batchKey,
  }) async {
    if (batchKey != null) {
      batchKey._batch.set(
        _fireStore.collection(path).doc(id),
        model.toJson(),
      );
      return null;
    }

    if (id == null) {
      final docRef = await _fireStore.collection(path).add(model.toJson());
      return docRef.id;
    }
    await _fireStore.collection(path).doc(id).set(model.toJson());
    return id;
  }

  /// Similar to [write], but updates data in the document.
  Future<void> update({
    required String path,
    required StoreModel model,
    required String id,
    BatchKey? batchKey,
  }) async {
    if (batchKey != null) {
      batchKey._batch.update(
        _fireStore.collection(path).doc(id),
        model.toJson(),
      );
      return;
    }

    return await _fireStore.collection(path).doc(id).update(model.toJson());
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
  Future<T?> read<T extends StoreModel>({
    required String path,
    required String id,
    required StoreModelConverter<T> converter,
  }) async {
    final documentSnapshot = await _fireStore.collection(path).doc(id).get();
    final doc = documentSnapshot.data();

    if (doc == null) return null;

    doc['id'] = documentSnapshot.id;
    return converter(doc);
  }

  /// Queries a fire-store collection for the [path].
  Future<List<T>> readAll<T extends StoreModel>({
    required String path,
    required StoreModelConverter<T> converter,
    SnapshotQuery? query,
  }) async {
    var ref = _fireStore.collection(path);
    if (query != null) {
      final queryRef = query(ref);
      if (queryRef is CollectionReference<Map<String, dynamic>>) ref = queryRef;
    }

    final querySnapshots = await ref.get();

    final _models = <T>[];
    for (final snapshot in querySnapshots.docs) {
      final doc = snapshot.data();
      doc['id'] = snapshot.id;
      _models.add(converter(doc));
    }
    return _models;
  }

  /// Queries a fire-store document for the [path] and [id].
  Stream<T> watch<T extends StoreModel>({
    required String path,
    required String id,
    required StoreModelConverter<T> converter,
  }) async* {
    final docStream = _fireStore.collection(path).doc(id).snapshots();

    await for (final snapshot in docStream) {
      final doc = snapshot.data();
      if (doc != null) {
        doc['id'] = snapshot.id;
        yield converter(doc);
      }
    }
  }

  /// Queries a fire-store collection for the [path].
  Stream<List<T>> watchAll<T extends StoreModel>({
    required String path,
    required StoreModelConverter<T> converter,
    SnapshotQuery? query,
  }) async* {
    var ref = _fireStore.collection(path);
    if (query != null) {
      final queryRef = query(ref);
      if (queryRef is CollectionReference<Map<String, dynamic>>) ref = queryRef;
    }

    await for (final qs in ref.snapshots()) {
      final _models = <T>[];

      for (final snapshot in qs.docs) {
        final doc = snapshot.data();
        doc['id'] = snapshot.id;
        _models.add(converter(doc));
      }
      yield _models;
    }
  }
}

abstract class StoreModel extends Equatable {
  const StoreModel();
  Map<String, dynamic> toJson();
}

typedef StoreModelConverter<T extends StoreModel> = T Function(
    Map<String, dynamic>);

typedef SnapshotQuery<T> = Query<T> Function(CollectionReference<T>);

class BatchKey {
  WriteBatch _batch;

  BatchKey([FirebaseFirestore? fireStore])
      : _batch = (fireStore ?? FirebaseFirestore.instance).batch();

  Future<void> commit() => _batch.commit();
}
