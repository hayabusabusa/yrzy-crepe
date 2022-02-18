import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crepe_core/provider/crp_collection_refrencable.dart';
import 'package:crepe_core/provider/crp_query_referencable.dart';

class CRPFirestoreProvider {

  static CRPFirestoreProvider? _instance;

  static CRPFirestoreProvider get instance {
    final instance = _instance;
    if (instance != null) {
      return instance;
    }

    final newInstance = CRPFirestoreProvider._();
    _instance = newInstance;
    return newInstance;
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CRPFirestoreProvider._();

  Future<QuerySnapshot<T>> getFromCollection<T>({
    required CRPCollectionReferencable<T> collectionReferencable,
  }) {
    return collectionReferencable.toReference(_db).get();
  }

  Future<QuerySnapshot<T>> getWithQuery<T>({
    required CRPQueryReferencable<T> queryReferencable,
  }) {
    return queryReferencable.toReference(_db).get();
  }
}