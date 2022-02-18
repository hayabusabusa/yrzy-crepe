import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/entity/entity.dart';
import 'package:crepe_core/provider/crp_referencable.dart';

abstract class CRPCollectionReferencable<T> extends CRPReferencable<T, CollectionReference<T>> {}

class CRPBookCollectionReference implements CRPCollectionReferencable<Book> {
  final CRPCollection collection;

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
    return db.collection(collection.rawValue)
      .withConverter(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}