import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';
import 'package:crepe_ui/crepe_ui.dart';

import 'package:crepe/app_router.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("お気に入り一覧"),
      ),
      body: const _Body(),
    );
  }
}

// MARK: - Body

class _Body extends StatefulWidget {
  const _Body({ Key? key }) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  /// Firestore から読み込んできたお気に入りの本一覧.
  List<FavoriteBook> _favoriteBooks = [];
  /// 初回ロード中かどうかのフラグ.
  bool _isLoading = true;
  /// ページネーションのロード中かどうかのフラグ.
  bool _isLoadingNextPage = false;
  /// ページネーションの最後のページに到達したかどうかのフラグ.
  bool _isReachLastPage = false;
  /// ページネーションで利用する、読み込んだお気に入りの本のデータで1番更新日が古い日付.
  DateTime? _lastCreatedAtDate;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    final uid = CRPAuthProvider.instance.uid();
    if (uid == null) {
      return;
    }

    final queryReferencable = CRPFavoritesPaginationQueryReference(uid: uid, orderBy: "createdAt", isDescending: true, startValues: [DateTime.now()], limit: 20);
    CRPFirestoreProvider.instance.getWithQuery(queryReferencable: queryReferencable)
      .then((value) {
        setState(() {
          _favoriteBooks = value.docs.map((e) => e.data()).toList();
          _lastCreatedAtDate = _favoriteBooks.isEmpty ? null : _favoriteBooks.last.createdAt;
          _isLoading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : CRPPaginationListView(
            scrollController: _controller, 
            itemCount: _favoriteBooks.length, 
            onReachBottom: () {
              // 次のページをロード中、もしくは追加で取得する要素がない場合は何もしない.
              if (_isLoadingNextPage || _isReachLastPage) {
                return;
              }
              _isLoadingNextPage = true;
              _fetchNextPageAfter(createdAtDate: _lastCreatedAtDate ?? DateTime.now());
            }, 
            itemBuilder: (_, index) {
              return _ListTile(
                book: _favoriteBooks[index], 
                onTap: () async {
                  final favoriteBook = _favoriteBooks[index];
                  final documentReferencable = CRPBooksDocumentReferencable(documentID: favoriteBook.id);
                  
                  try {
                    final snapshot = await CRPFirestoreProvider.instance.getDocument(documentReferencable: documentReferencable);
                    final book = snapshot.data();
                    if (book == null) {
                      return;
                    }

                    final args = ViewerScreenArgs(book: book);
                    Navigator.of(context).pushNamed(AppRouter.viewer, arguments: args);
                  } catch(_) {
                    // 現状は何もしない.
                  }
                },
              );
            },
          )
    );
  }

  /// 指定された日付以降のページを追加で読み込む
  void _fetchNextPageAfter({
    required DateTime createdAtDate,
  }) async {
    final uid = CRPAuthProvider.instance.uid();
    if (uid == null) {
      return;
    }

    try {
      final queryReferencable = CRPFavoritesPaginationQueryReference(uid: uid, orderBy: "createdAt", isDescending: true, startValues: [createdAtDate], limit: 20);
      final snapshot = await CRPFirestoreProvider.instance.getWithQuery(queryReferencable: queryReferencable);
      final favoriteBooks = snapshot.docs.map((e) => e.data()).toList();

      setState(() {
        _favoriteBooks.addAll(favoriteBooks);
        _lastCreatedAtDate = favoriteBooks.isEmpty ? null : favoriteBooks.last.createdAt;
        _isReachLastPage = favoriteBooks.isEmpty;
        _isLoadingNextPage = false;
      });
    } catch(error) {
      debugPrint(error.toString());
    }
  }
}

// MARK: - List tile

class _ListTile extends StatelessWidget {
  final FavoriteBook book;
  final VoidCallback onTap;

  const _ListTile({ 
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CRPNetworkImage(
        imageURL: book.thumbnailURL ?? "",
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      subtitle: Text(
        book.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}