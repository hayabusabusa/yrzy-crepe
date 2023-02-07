import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';
import 'package:crepe_ui/crepe_ui.dart';

import 'package:crepe/app_router.dart';

// MARK: - Screen

class BooksScreen extends StatelessWidget {
  const BooksScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("本一覧"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRouter.favorites);
            }, 
            child: const Text(
              "お気に入り",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ),
        ],
      ),
      body: const _Body(),
    );
  }
}

// MARK: - Body

class _Body extends StatefulWidget {
  const _Body({ Key? key }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final List<Book> _books = [];
  bool _isLoading = true;
  bool _isLoadingNextPage = false;
  DateTime? _lastCreatedAtDate;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() { 
      final maxScrollExtent = _controller.position.maxScrollExtent;
      final position = _controller.position.pixels;
      final lastCreatedAtDate = _lastCreatedAtDate;

      if (lastCreatedAtDate != null) {
        // `スクロール領域 - 現在のスクロール位置` で残りのスクロール可能領域を計算する.
        // 慣性スクロール分を無視するため 0 <= 残りのスクロール領域 <= 220 になったら次のページを取得する.
        final diff = maxScrollExtent - position;
        final isReachBottom = 0 <= diff && diff <= 220;
        if (isReachBottom && !_isLoadingNextPage) {
          _isLoadingNextPage = true;
          _fetchBooks(startDateTime: lastCreatedAtDate);
        }
      }
    });

    // サインインしていない場合は、サインインの処理をしてからデータの取得を行う.
    if (!CRPAuthProvider.instance.isSignIn()) {
      CRPAuthProvider.instance.signInAsAnonymousUser()
        .then((value) async {
          // サインイン後の UID を利用してユーザーのデータを Firestore につくる.
          final uid = value.user?.uid;
          if (uid != null) {
            final user = User(id: uid, createdAt: DateTime.now());
            final documentReferencable = CRPUsersDocumentReferencable(uid: uid);

            await CRPFirestoreProvider.instance.setDocument(data: user, documentReferencable: documentReferencable);
          }

          _fetchBooks(startDateTime: DateTime.now());
        });
      return;
    }

    _fetchBooks(startDateTime: DateTime.now());
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
            child: CircularProgressIndicator()
          )
        : Scrollbar(
          controller: _controller,
          child: RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: ListView.builder(
                itemCount: _books.length,
                controller: _controller,
                itemBuilder: (_, index) {
                  final book = _books[index];
                  return _ListTile(
                    book: book,
                    onTap: () {
                      final args = ViewerScreenArgs(book: book);
                      Navigator.of(context).pushNamed(AppRouter.viewer, arguments: args);
                    },
                  );
                },
              ),
          ),
        ),
    );
  }

  void _fetchBooks({
    required DateTime startDateTime,
  }) async {
    try {
      final reference = CRPBookPaginationQueryReference(collection: CRPCollection.book, orderBy: "createdAt", isDescending: true, startValues: [startDateTime], limit: 10);
      final snapshot = await CRPFirestoreProvider.instance.getWithQuery(queryReferencable: reference);
      final books = snapshot.docs.map((e) => e.data()).toList();

      setState(() {
        _books.addAll(books);
        _lastCreatedAtDate = _books.last.createdAt;
        _isLoading = false;
        _isLoadingNextPage = false;
      });
    } catch(error) {
      debugPrint(error.toString());
    }
  }

  void _refresh() async {
    setState(() {
      _isLoading = true;
      _books.clear();
    });

    _fetchBooks(startDateTime: DateTime.now());
  }
}

// MARK: - Private Widget

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
                  style: Theme.of(context).textTheme.bodySmall,
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