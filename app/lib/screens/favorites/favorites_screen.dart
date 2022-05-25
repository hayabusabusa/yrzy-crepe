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
  bool _isLoading = true;
  List<FavoriteBook> _books = [];

  @override
  void initState() {
    super.initState();

    final uid = CRPAuthProvider.instance.uid();
    if (uid == null) {
      return;
    }

    final collectionReferencable = CRPFavoritesCollectionReference(uid: uid);
    CRPFirestoreProvider.instance.getFromCollection(collectionReferencable: collectionReferencable)
      .then((value) {
        setState(() {
          _books = value.docs.map((e) => e.data()).toList();
          _isLoading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(microseconds: 200),
      child: _isLoading 
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
          itemCount: _books.length,
          itemBuilder: (_, index) {
            return _ListTile(
              book: _books[index], 
              onTap: () async {
                final favoriteBook = _books[index];
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