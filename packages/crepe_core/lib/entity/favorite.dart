
/// お気に入りに追加した作品を表すクラス.
class FavoriteBook {
  /// Firestore で割り当てられるデータの ID.
  final String id;
  /// 作品の ID.
  final String bookID;
  /// 作品のタイトル.
  final String title;
  /// 作品のサムネイル画像の URL.
  final String? thumbnailURL;

  FavoriteBook({
    required this.id,
    required this.bookID,
    required this.title,
    required this.thumbnailURL,
  });

  factory FavoriteBook.fromData({
    required String id,
    required Map<String, dynamic> data,
  }) {
    return FavoriteBook(
      id: id, 
      bookID: data["bookID"], 
      title: data["title"], 
      thumbnailURL: data["thumbnailURL"],
    );
  }

  Map<String, dynamic> toData() {
    final data = {
      "bookID": bookID,
      "title": title,
    };

    final thumbnailURL = this.thumbnailURL;
    if (thumbnailURL != null) {
      data["thumbnailURL"] = thumbnailURL;
    }

    return data;
  }
}