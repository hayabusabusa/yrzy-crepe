import 'package:flutter/material.dart';

import 'package:crepe_ui/crepe_ui.dart';
import 'package:crepe_core/crepe_core.dart';

// MARK: - Screen

class ViewerScreen extends StatelessWidget {
  final Book book;

  const ViewerScreen({ 
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: _Body(book: book),
    );
  }
}

// MARK: - Body

class _Body extends StatefulWidget {
  final Book book;

  const _Body({ 
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final PageController _controller = PageController();

  bool _isTapped = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: SafeArea(
        child: Stack(
          children: [
            // PageView
            PageView.builder(
              itemCount: widget.book.imageURLs.length,
              itemBuilder: (_, index) {
                return CRPNetworkImage(imageURL: widget.book.imageURLs[index]);
              },
              reverse: true,
              controller: _controller,
            ),
            // Footer
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _isTapped ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: AbsorbPointer(
                  absorbing: _isTapped,
                  child: _Footer(
                    min: 0, 
                    max: widget.book.imageURLs.length - 1, 
                    book: widget.book,
                    onChanged: (value) {
                      _controller.jumpToPage(value);
                    },
                    controller: _controller,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MARK: - Footer

class _Footer extends StatefulWidget {
  final int max;
  final int min;
  final Book book;
  final ValueChanged<int> onChanged;
  final PageController? controller;

  const _Footer({ 
    Key? key,
    required this.min,
    required this.max,
    required this.book,
    required this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> {
  double _selectedValue = 0;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.max.toDouble();

    widget.controller?.addListener(() { 
      final page = widget.controller?.page ?? 0;
      final selectedValue = widget.max - page;

      if (_selectedValue != selectedValue) {
        setState(() {
          _selectedValue = selectedValue;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Divider
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          // Slider
          Slider(
            min: widget.min.toDouble(),
            max: widget.max.toDouble(),
            value: _selectedValue,
            label: (widget.max - _selectedValue + 1).round().toString(),
            divisions: widget.max,
            onChanged: (value) {
              final invertedValue = widget.max - value;
              widget.onChanged(invertedValue.round());
          
              setState(() {
                _selectedValue = value;
              });
            }
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _FavoriteButton(book: widget.book,),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).errorColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }, 
                    child: const Text("閉じる")
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Favorite Button

class _FavoriteButton extends StatefulWidget {
  final Book book;

  const _FavoriteButton({ 
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<_FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<_FavoriteButton> {

  @override
  Widget build(BuildContext context) {
    final uid = CRPAuthProvider.instance.uid();
    if (uid == null) {
      return const TextButton(
        onPressed: null, 
        child: Text("お気に入り"),
      );
    }

    final documentReferencable = CRPFavoritesDocumentReferencable(
      uid: uid, 
      documentID: widget.book.id
    );

    return FutureBuilder<bool>(
      future: CRPFirestoreProvider.instance.isExistsDocument(documentReferencable: documentReferencable),
      builder: (_, asyncSnapshot) {
        if (!asyncSnapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (asyncSnapshot.hasError) {
          return const TextButton(
            onPressed: null, 
            child: Text("エラーが発生しました")
          );
        }

        final isExists = asyncSnapshot.data ?? false;
        return isExists 
          ? TextButton.icon(
            onPressed: () { 
              /* お気に入りから削除の処理を入れる. */
            }, 
            icon: const Icon(Icons.check_rounded),
            label: const Text("お気に入り済み"),
          )
          : TextButton(
            onPressed: () async {
              final favoriteBook = FavoriteBook(
                id: widget.book.id, 
                title: widget.book.title, 
                thumbnailURL: widget.book.thumbnailURL,
              );
              
              try {
                await CRPFirestoreProvider.instance.setDocument(data: favoriteBook, documentReferencable: documentReferencable);
              } catch (_) {
                // 今のところ何もしない.
              }

              // ボタンの状態を更新するために、Widget を更新する.
              setState(() {});
            }, 
            child: const Text("お気に入り")
          );
      },
    );
  }
}