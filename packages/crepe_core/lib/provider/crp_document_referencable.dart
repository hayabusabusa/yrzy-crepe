import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/entity/entity.dart';
import 'package:crepe_core/provider/crp_referencable.dart';

abstract class CRPDocumentReferencable<T> extends CRPReferencable<T, DocumentReference<T>> {}

/// `/users/{uid}/favorites/{documentID}` のドキュメントにアクセスするリファレンス.
class CRPFavoritesDocumentReferencable extends CRPDocumentReferencable<FavoriteBook> {
  final String uid;
  final String documentID;

  CRPFavoritesDocumentReferencable({
    required this.uid,
    required this.documentID,
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
  DocumentReference<FavoriteBook> toReference(FirebaseFirestore db) {
    return db.collection(CRPCollection.users.rawValue + "/$uid" + "/favorites")
      .doc(documentID)
      .withConverter(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!),
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}