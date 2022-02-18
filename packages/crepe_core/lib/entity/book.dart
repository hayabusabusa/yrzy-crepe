import 'package:cloud_firestore/cloud_firestore.dart';

/// 作品を表すクラス.
class Book {
  /// Firestore で割り振られているデータの ID.
  final String id;
  /// 作品のタイトル.
  final String title;
  /// 作品の URL.
  final String url;
  /// 作品が追加された日付.
  final DateTime createdAt;
  /// 作品の画像一覧.
  final List<String> imageURLs;
  /// 作品のカテゴリー一覧.
  final List<String> categories;
  /// 作品の著者.
  final String? author;
  /// 作品のサムネイル画像の URL.
  final String? thumbnailURL;

  Book({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
    required this.imageURLs,
    required this.categories,
    this.author,
    this.thumbnailURL
  });

  factory Book.fromData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    final imageURLs = (data["imageURLs"] as List<dynamic>).map((e) => e as String).toList();
    final categories = (data["categories"] as List<dynamic>).map((e) => e as String).toList();
    return Book(
      id: id, 
      title: data["title"], 
      url: data["url"], 
      createdAt: (data["createdAt"] as Timestamp).toDate(), 
      imageURLs: imageURLs, 
      categories: categories,
      author: data["author"],
      thumbnailURL: data["thumbnailURL"],
    );
  }

  Map<String, dynamic> toData() {
    final data =  {
      "title": title,
      "url": url,
      "createdAt": createdAt,
      "imageURLs": imageURLs,
      "categories": categories,
    };

    final author = this.author;
    if (author != null) {
      data["author"] = author;
    }

    final thumbnailURL = this.thumbnailURL;
    if (thumbnailURL != null) {
      data["thumbnailURL"] = thumbnailURL;
    }

    return data;
  }
}