import 'package:clean_framework/clean_framework_defaults.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  final mock = MockFirebaseFirestore();
  final client = FirebaseClient(mock);

  setUpAll(() {
    registerFallbackValue(mock);
  });

  group('FirebaseClient tests:: ', () {
    test('write; without id', () async {
      final path = 'test-path';

      final mockCollectionRef = MockCollectionReference<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.add(any())).thenAnswer(
        (_) async => MockDocumentReference(),
      );

      final id = await client.write(
        path: path,
        content: {'name': 'Sarbagya Dhaubanjar'},
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.add({'name': 'Sarbagya Dhaubanjar'}),
      ]);

      expect(id, 'test-id');
    });

    test('write; with id', () async {
      final path = 'test-path';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any())).thenAnswer((_) async {});

      final id = await client.write(
        path: path,
        content: {'name': 'Sarbagya Dhaubanjar'},
        id: 'my-id',
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.doc('my-id'),
        () => mockDocRef.set({'name': 'Sarbagya Dhaubanjar'}),
      ]);

      expect(id, 'my-id');
    });

    test('write batch', () async {
      final path = 'test-path';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      final mockWriteBatch = MockWriteBatch();

      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.set(any())).thenAnswer((_) async {});
      when(() => mockWriteBatch.commit()).thenAnswer((_) async => null);
      when(() => mock.batch()).thenReturn(mockWriteBatch);

      final batchKey = BatchKey(mock);

      await client.write(
        path: path,
        content: {'name': 'Sarbagya Dhaubanjar'},
        id: 'my-id',
        batchKey: batchKey,
      );
      await batchKey.commit();

      verifyInOrder([
        () => mock.batch(),
        () => mock.collection(path),
        () => mockCollectionRef.doc('my-id'),
        () => mockWriteBatch.commit(),
      ]);
    });

    test('update', () async {
      final path = 'test-path';
      final id = 'test-id';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});

      await client.update(
        path: path,
        content: {'name': 'Sarbagya Dhaubanjar'},
        id: id,
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.doc(id),
        () => mockDocRef.update({'name': 'Sarbagya Dhaubanjar'}),
      ]);
    });

    test('update batch', () async {
      final path = 'test-path';
      final id = 'test-id';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      final mockWriteBatch = MockWriteBatch();

      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.update(any())).thenAnswer((_) async {});
      when(() => mockWriteBatch.commit()).thenAnswer((_) async => null);
      when(() => mock.batch()).thenReturn(mockWriteBatch);

      final batchKey = BatchKey(mock);

      await client.update(
        path: path,
        content: {'name': 'Sarbagya Dhaubanjar'},
        id: id,
        batchKey: batchKey,
      );
      await batchKey.commit();

      verifyInOrder([
        () => mock.batch(),
        () => mock.collection(path),
        () => mockCollectionRef.doc(id),
        () => mockWriteBatch.update(
              mockDocRef,
              {'name': 'Sarbagya Dhaubanjar'},
            ),
        () => mockWriteBatch.commit(),
      ]);
    });

    test('delete', () async {
      final path = 'test-path';
      final id = 'test-id';

      final mockDocRef = MockDocumentReference<_Json>();
      when(() => mock.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.delete()).thenAnswer((_) async {});

      await client.delete(
        path: path,
        id: id,
      );

      verifyInOrder(
        [
          () => mock.doc(path),
          () => mockDocRef.delete(),
        ],
      );
    });

    test('delete batch', () async {
      final path = 'test-path';
      final id = 'test-id';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      final mockWriteBatch = MockWriteBatch();

      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mock.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.delete()).thenAnswer((_) async {});
      when(() => mockWriteBatch.commit()).thenAnswer((_) async => null);
      when(() => mock.batch()).thenReturn(mockWriteBatch);

      final batchKey = BatchKey(mock);

      await client.delete(
        path: path,
        id: id,
        batchKey: batchKey,
      );
      await batchKey.commit();

      verifyInOrder(
        [
          () => mock.batch(),
          () => mock.collection(path),
          () => mockCollectionRef.doc(id),
          () => mockWriteBatch.delete(mockDocRef),
          () => mockWriteBatch.commit(),
        ],
      );
    });

    test('read', () async {
      final path = 'test-path';
      final id = 'test-id';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockDocRef = MockDocumentReference<_Json>();
      final mockDocSnapshot = MockDocumentSnapshot<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
      when(() => mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(() => mockDocSnapshot.data()).thenReturn({'name': 'Test Shrestha'});

      final data = await client.read(
        path: path,
        id: id,
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.doc(id),
        () => mockDocRef.get(),
        () => mockDocSnapshot.data(),
      ]);

      expect(data, {'name': 'Test Shrestha', 'id': 'test-doc-id'});
    });

    test('readAll', () async {
      final path = 'test-path';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockQuerySnapshot = MockQuerySnapshot<_Json>();
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.get()).thenAnswer(
        (_) async => mockQuerySnapshot,
      );
      when(() => mockQuerySnapshot.docs).thenReturn([
        mockQueryDocSnapshot,
        mockQueryDocSnapshot,
      ]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({'name': 'Test Name'});

      final data = await client.readAll(
        path: path,
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.get(),
        () => mockQuerySnapshot.docs,
      ]);

      verify(() => mockQueryDocSnapshot.data()).called(2);

      expect(
        data,
        [
          {'name': 'Test Shrestha', 'id': 'test-doc-id'},
          {'name': 'Test Shrestha', 'id': 'test-doc-id'},
        ],
      );
    });

    test('readAll with query', () async {
      final path = 'test-path';

      final mockCollectionRef = MockCollectionReference<_Json>();
      final mockQuerySnapshot = MockQuerySnapshot<_Json>();
      final mockQueryDocSnapshot = MockQueryDocumentSnapshot<_Json>();
      when(() => mock.collection(path)).thenReturn(mockCollectionRef);
      when(() => mockCollectionRef.get()).thenAnswer(
        (_) async => mockQuerySnapshot,
      );
      when(() => mockQuerySnapshot.docs).thenReturn([
        mockQueryDocSnapshot,
        mockQueryDocSnapshot,
      ]);
      when(() => mockQueryDocSnapshot.data()).thenReturn({'name': 'Test Name'});

      client.createQuery(path, (ref) => ref);

      final data = await client.readAll(
        path: path,
      );

      verifyInOrder([
        () => mock.collection(path),
        () => mockCollectionRef.get(),
        () => mockQuerySnapshot.docs,
      ]);

      verify(() => mockQueryDocSnapshot.data()).called(2);

      expect(
        data,
        [
          {'name': 'Test Shrestha', 'id': 'test-doc-id'},
          {'name': 'Test Shrestha', 'id': 'test-doc-id'},
        ],
      );
    });

    //   test('watch', () async {
    //     final path = 'test-path';
    //     final id = 'test-id';

    //     final mockCollectionRef = MockCollectionReference<_Json>();
    //     final mockDocRef = MockDocumentReference<_Json>();
    //     final mockDocSnapshot = MockDocumentSnapshot<_Json>();
    //     when(() => mock.collection(path)).thenReturn(mockCollectionRef);
    //     when(() => mockCollectionRef.doc(any())).thenReturn(mockDocRef);
    //     when(() => mockDocRef.snapshots()).thenAnswer((_) async* {
    //       yield mockDocSnapshot;
    //     });
    //     when(() => mockDocSnapshot.data()).thenReturn({'name': 'Test Shrestha'});

    //     client
    //         .watch(
    //       path: path,
    //       id: id,
    //       converter: (rawData) => UserModel.fromJson(rawData),
    //     )
    //         .listen(
    //       expectAsync1(
    //         (data) {
    //           verifyInOrder([
    //             () => mock.collection(path),
    //             () => mockCollectionRef.doc(id),
    //             () => mockDocRef.snapshots(),
    //             () => mockDocSnapshot.data(),
    //           ]);

    //           expect(data, UserModel(name: 'Test Shrestha', id: 'test-doc-id'));
    //         },
    //       ),
    //     );
    //   });

    //   test('watchAll', () async {
    //     final path = 'test-path';

    //     final mockCollectionRef = MockCollectionReference<_Json>();
    //     final mockQuerySnapshot = MockQuerySnapshot<_Json>();
    //     final mockQueryDocSnapshot = MockQueryDocumentSnapshot<_Json>();
    //     when(() => mock.collection(path)).thenReturn(mockCollectionRef);
    //     when(() => mockCollectionRef.snapshots()).thenAnswer((_) async* {
    //       yield mockQuerySnapshot;
    //       await Future.delayed(const Duration(milliseconds: 10));
    //       yield mockQuerySnapshot;
    //     });
    //     when(() => mockQuerySnapshot.docs).thenReturn([
    //       mockQueryDocSnapshot,
    //       mockQueryDocSnapshot,
    //     ]);
    //     when(() => mockQueryDocSnapshot.data()).thenReturn({'name': 'Test Name'});

    //     int count = 1;
    //     client
    //         .watchAll(
    //           path: path,
    //           converter: (rawData) => UserModel.fromJson(rawData),
    //           query: (ref) => ref,
    //         )
    //         .listen(
    //           expectAsync1(
    //             (data) {
    //               if (count == 1) {
    //                 verifyInOrder([
    //                   () => mock.collection(path),
    //                   () => mockCollectionRef.snapshots(),
    //                   () => mockQuerySnapshot.docs,
    //                   () => mockQueryDocSnapshot.data(),
    //                   () => mockQueryDocSnapshot.data(),
    //                 ]);
    //               }
    //               if (count == 2) {
    //                 verifyInOrder([
    //                   () => mockQuerySnapshot.docs,
    //                   () => mockQueryDocSnapshot.data(),
    //                   () => mockQueryDocSnapshot.data(),
    //                 ]);
    //               }

    //               expect(
    //                 data,
    //                 [
    //                   UserModel(name: 'Test Name', id: 'test-query-doc-id'),
    //                   UserModel(name: 'Test Name', id: 'test-query-doc-id'),
    //                 ],
    //               );
    //               count += 1;
    //             },
    //             count: 2,
    //           ),
    //         );
    //   });
  });
}

typedef _Json = Map<String, dynamic>;

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

//ignore: subtype_of_sealed_class
class MockDocumentReference<T extends Object?> extends Mock
    implements DocumentReference<T> {
  @override
  String get id => 'test-id';
}

//ignore: subtype_of_sealed_class
class MockCollectionReference<T extends Object?> extends Mock
    implements CollectionReference<T> {}

//ignore: subtype_of_sealed_class
class MockDocumentSnapshot<T extends Object?> extends Mock
    implements DocumentSnapshot<T> {
  @override
  String get id => 'test-doc-id';
}

//ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot<T extends Object?> extends Mock
    implements QueryDocumentSnapshot<T> {
  @override
  String get id => 'test-query-doc-id';
}

class MockQuerySnapshot<T extends Object?> extends Mock
    implements QuerySnapshot<T> {}

class MockWriteBatch extends Mock implements WriteBatch {}
