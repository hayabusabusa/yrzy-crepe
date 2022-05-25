import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  /// Firestore で割り振られているデータの ID.
  /// 
  /// Auth でサインインしている UID と一致させる.
  final String id;
  /// ユーザーが作成された日付.
  final DateTime createdAt;

  User({
    required this.id,
    required this.createdAt,
  });

  factory User.fromData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return User(
      id: id, 
      createdAt: (data["createdAt"] as Timestamp).toDate()
    );
  }

  Map<String, dynamic> toData() {
    return {
      "createdAt": createdAt,
    };
  }
}