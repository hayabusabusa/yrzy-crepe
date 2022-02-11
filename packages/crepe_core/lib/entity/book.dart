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
}