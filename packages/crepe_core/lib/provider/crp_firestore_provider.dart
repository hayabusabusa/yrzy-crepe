import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crepe_core/crepe_core.dart';

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

  /// 任意のコレクションからドキュメント一覧を取得する.
  Future<QuerySnapshot<T>> getFromCollection<T>({
    required CRPCollectionReferencable<T> collectionReferencable,
  }) {
    return collectionReferencable.toReference(_db).get();
  }

  /// 任意のコレクションにドキュメントを新規に追加する.
  Future<DocumentReference<T>> addDocument<T>({
    required T data,
    required CRPCollectionReferencable<T> collectionReferencable,
  }) {
    return collectionReferencable.toReference(_db).add(data);
  }

  /// 単一のドキュメントを取得する.
  Future<DocumentSnapshot<T>> getDocument<T>({
    required CRPDocumentReferencable<T> documentReferencable,
  }) {
    return documentReferencable.toReference(_db).get();
  }

  /// ドキュメントを追加、もしくは更新する.
  Future<void> setDocument<T>({
    required T data,
    required CRPDocumentReferencable documentReferencable,
  }) {
    return documentReferencable.toReference(_db).set(data, SetOptions(merge: true));
  }

  /// ドキュメントが存在するかどうか確認する.
  Future<bool> isExistsDocument<T>({
    required CRPDocumentReferencable documentReferencable,
  }) async {
    final snapshot = await documentReferencable.toReference(_db).get();
    return snapshot.exists;
  }

  /// 任意のコレクションからクエリを利用してドキュメント一覧を取得する。
  Future<QuerySnapshot<T>> getWithQuery<T>({
    required CRPQueryReferencable<T> queryReferencable,
  }) {
    return queryReferencable.toReference(_db).get();
  }
}