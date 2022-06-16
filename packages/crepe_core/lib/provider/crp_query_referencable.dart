import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/entity/entity.dart';
import 'package:crepe_core/provider/crp_referencable.dart';

abstract class CRPQueryReferencable<T> extends CRPReferencable<T, Query<T>> {}

/// `/book` のドキュメント一覧にページネーションの機能付きでアクセスするリファレンス.
class CRPBookPaginationQueryReference implements CRPQueryReferencable<Book> {
  final CRPCollection collection;
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
    return db.collection(collection.rawValue)
      .orderBy(orderBy, descending: isDescending)
      .startAfter(startValues)
      .limit(limit)
      .withConverter<Book>(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}

/// `/users/{uid}/favorites` のドキュメント一覧にページネーションの機能付きでアクセスするリファレンス.
class CRPFavoritesPaginationQueryReference implements CRPQueryReferencable<FavoriteBook> {
  final String uid;
  final String orderBy;
  final bool isDescending;
  final List<Object?> startValues;
  final int limit;

  CRPFavoritesPaginationQueryReference({
    required this.uid,
    required this.orderBy,
    required this.isDescending,
    required this.startValues,
    required this.limit,
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
  Query<FavoriteBook> toReference(FirebaseFirestore db) {
    return db.collection(CRPCollection.users.rawValue + "/$uid" + "/favorites")
      .orderBy(orderBy, descending: isDescending)
      .startAfter(startValues)
      .limit(limit)
      .withConverter(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}

/// `/book` のドキュメント一覧から任意の作者で検索するリファレンス.
class CRPSearchBookWithAutherQueryReference implements CRPQueryReferencable<Book> {
  final String author;
  final DateTime createdAt;

  CRPSearchBookWithAutherQueryReference({
    required this.author,
    required this.createdAt,
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
    return db.collection(CRPCollection.book.rawValue)
      .where("author", isEqualTo: author)
      .limit(10)
      .withConverter<Book>(
        fromFirestore: (snapshot, _) => fromFirestore(snapshot.id, snapshot.data()!), 
        toFirestore: (document, _) => toFirestore(document),
      );
  }
}