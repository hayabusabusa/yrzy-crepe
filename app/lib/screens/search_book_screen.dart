import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';
import 'package:crepe_ui/crepe_ui.dart';

class SearchBookScreen extends StatelessWidget {
  /// ひとまず作者検索のみ.
  final String author;

  const SearchBookScreen({ 
    Key? key,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("作者: $author で検索"),
      ),
      body: _Body(author: author,),
    );
  }
}

// MARK: - Body

class _Body extends StatefulWidget {
  final String author;

  const _Body({ 
    Key? key,
    required this.author
  }) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  /// Firestore から取得したデータ一覧.
  final List<Book> _books = [];
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
    _fetchBooks(dateTime: DateTime.now());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          threshold: 220.0,
          scrollController: _controller, 
          itemCount: _books.length,
          onReachBottom: () {
            // TODO: 複合クエリが必要だったのでページネーションをオフにする.
            // 次のページをロード中、もしくは追加で取得する要素がない場合は何もしない.
            // if (_isLoadingNextPage || _isReachLastPage) {
            //   return;
            // }
            // _isLoadingNextPage = true;
            // _fetchBooks(dateTime: _lastCreatedAtDate ?? DateTime.now());
          }, 
          itemBuilder: (_, index) {
            return _ListTile(
              book: _books[index], 
              onTap: () {},
            );
          },
        )
    );
  }

  /// Firestore にデータを検索しにいく.
  void _fetchBooks({
    required DateTime dateTime,
  }) async {
    try {
      final queryReferencable = CRPSearchBookWithAutherQueryReference(
        author: widget.author, 
        createdAt: dateTime
      );
      final snapshot = await CRPFirestoreProvider.instance.getWithQuery(queryReferencable: queryReferencable);
      final books = snapshot.docs.map((e) => e.data()).toList();

      setState(() {
        _books.addAll(books);
        _isLoading = false;
        _isLoadingNextPage = false;
        _isReachLastPage = books.isEmpty;
        _lastCreatedAtDate = books.isEmpty ? null : books.last.createdAt;
      });
    } catch(error) {
      debugPrint(error.toString());
    }
  }
}

// MARK: - ListTile

class _ListTile extends StatelessWidget {
  final Book book;
  final void Function() onTap;

  const _ListTile({
    Key? key,
    required this.book,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CRPNetworkImage(
            imageURL: book.thumbnailURL ?? "",
            height: 220,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  book.title,
                  style: Theme.of(context).textTheme.bodyMedium?.merge(const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8.0,),
                Text(
                  "${book.createdAt.year}-${book.createdAt.month}-${book.createdAt.day}",
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}