import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CRPReferencable<T, U> {
  T fromFirestore(Map<String, dynamic> data);
  Map<String, dynamic> toFirestore(T document);
  U toReference(FirebaseFirestore db);
}

abstract class CRPQueryReferencable<T> extends CRPReferencable<T, Query<T>> {}

abstract class CRPCollectionReferencable<T> extends CRPReferencable<T, CollectionReference<T>> {}
