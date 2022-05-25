import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/entity/entity.dart';
import 'package:crepe_core/provider/crp_referencable.dart';

abstract class CRPCollectionReferencable<T> extends CRPReferencable<T, CollectionReference<T>> {}

/// `/book` コレクションへのリファレンス.
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

/// `/users/{uid}/favorites` へのリファレンス.
class CRPFavoritesCollectionReference implements CRPCollectionReferencable<FavoriteBook> {
  final String uid;

  CRPFavoritesCollectionReference({
    required this.uid,
  });

  @override
  FavoriteBook fromFirestore(String id, Map<String, dynamic> data) {
    return FavoriteBook.fromData(id: id, data: data);
  }

  @override
  Map<String, dynamic> toFirestore(FavoriteBook document) {
    return document.toData();
  }

  @override
  CollectionReference<FavoriteBook> toReference(FirebaseFirestore db) {
    return db.collection(CRPCollection.users.rawValue + "/$uid" + "/favorites")
      .withConverter(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!),
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}