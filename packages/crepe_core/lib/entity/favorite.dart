
/// お気に入りに追加した作品を表すクラス.
class FavoriteBook {
  /// Firestore のデータに割り振られている ID.
  /// 
  /// 作品の ID と同じ ID を割り振る.
  final String id;
  /// 作品のタイトル.
  final String title;
  /// 作品のサムネイル画像の URL.
  final String? thumbnailURL;

  FavoriteBook({
    required this.id,
    required this.title,
    required this.thumbnailURL,
  });

  factory FavoriteBook.fromData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return FavoriteBook(
      id: id, 
      title: data["title"], 
      thumbnailURL: data["thumbnailURL"],
    );
  }

  Map<String, dynamic> toData() {
    final data = {
      "title": title,
    };

    final thumbnailURL = this.thumbnailURL;
    if (thumbnailURL != null) {
      data["thumbnailURL"] = thumbnailURL;
    }

    return data;
  }
}