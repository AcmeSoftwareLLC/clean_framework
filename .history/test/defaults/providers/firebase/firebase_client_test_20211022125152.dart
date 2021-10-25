import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

void main() {}

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
