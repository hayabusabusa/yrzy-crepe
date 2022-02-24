import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';
import 'package:crepe_ui/crepe_ui.dart';

// MARK: - Screen

class BooksScreen extends StatelessWidget {
  const BooksScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("本一覧"),
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

  ScrollController? _controller;

  @override
  void initState() {
    super.initState();

    // NOTE: サインインしていない場合は、サインインの処理をしてからデータの取得を行う.
    if (!CRPAuthProvider.instance.isSignIn()) {
      CRPAuthProvider.instance.signInAsAnonymousUser()
        .then((value) {
          _fetchBooks(startDateTime: DateTime.now());
        });
      return;
    }

    _fetchBooks(startDateTime: DateTime.now());
  }

  @override
  void didChangeDependencies() {
    _controller = PrimaryScrollController.of(context);
    _controller?.addListener(() { 
      final maxScrollExtent = _controller?.position.maxScrollExtent;
      final position = _controller?.position.pixels;
      final lastCreatedAtDate = _lastCreatedAtDate;

      if (maxScrollExtent != null && position != null && lastCreatedAtDate != null) {
        final diff = maxScrollExtent - position;
        final isReachBottom = diff <= 80;
        if (isReachBottom && !_isLoadingNextPage) {
          _isLoadingNextPage = true;
          _fetchBooks(startDateTime: lastCreatedAtDate);
        }
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller?.dispose();
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
          child: RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: ListView.builder(
                itemCount: _books.length,
                controller: _controller,
                itemBuilder: (_, index) {
                  final book = _books[index];
                  return _ListTile(book: book);
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
    // NOTE: リロードすると `ListView` が新しくなるので、ここで `ScrollController` からの参照をリセットする必要がある.
    _controller?.dispose();

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

  const _ListTile({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
        ],
      ),
    );
  }
}