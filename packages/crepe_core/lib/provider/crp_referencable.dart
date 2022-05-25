import 'package:cloud_firestore/cloud_firestore.dart';

abstract class CRPReferencable<T, U> {
  T fromFirestore(String id, Map<String, dynamic> data);
  Map<String, dynamic> toFirestore(T document);
  U toReference(FirebaseFirestore db);
}

enum CRPCollection {
  book,
  users,
}

extension CRPCollectionExtension on CRPCollection {
  String get rawValue {
    switch (this) {
      case CRPCollection.book:
        return "public/v1/books";
      case CRPCollection.users:
        return "public/v1/users";
    }
  }
}