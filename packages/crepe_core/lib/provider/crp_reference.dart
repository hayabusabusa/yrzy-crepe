import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/entity/entity.dart';
import 'package:crepe_core/provider/crp_referencable.dart';

class CRPBookCollectionReference implements CRPCollectionReferencable<Book> {
  final String collection;

  CRPBookCollectionReference({
    required this.collection,
  });

  @override
  Book fromFirestore(String id, Map<String, dynamic> data) {
    return Book.fromData(id: id, data: data);
  }

  @override
  Map<String, dynamic> toFirestore(Book document) {
    return document.toData();
  }

  @override
  CollectionReference<Book> toReference(FirebaseFirestore db) {
    return db.collection(collection)
      .withConverter(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}

class CRPBookPaginationQueryReference implements CRPQueryReferencable<Book> {
  final String collection;
  final String orderBy;
  final bool isDescending;
  final List<Object?> startValues;
  final int limit;

  CRPBookPaginationQueryReference({
    required this.collection,
    required this.orderBy,
    required this.isDescending,
    required this.startValues,
    required this.limit,
  });

  @override
  Book fromFirestore(String id, Map<String, dynamic> data) {
    return Book.fromData(id: id, data: data);
  }

  @override
  Map<String, dynamic> toFirestore(Book document) {
    return document.toData();
  }

  @override
  Query<Book> toReference(FirebaseFirestore db) {
    return db.collection(collection)
      .orderBy(orderBy, descending: isDescending)
      .startAt(startValues)
      .limit(limit)
      .withConverter<Book>(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}