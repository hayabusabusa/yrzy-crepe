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
      body: _Body(imageURLs: book.imageURLs),
    );
  }
}

// MARK: - Body

class _Body extends StatefulWidget {
  final List<String> imageURLs;

  const _Body({ 
    Key? key,
    required this.imageURLs,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final PageController _controller = PageController();

  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTapped = !_isTapped;
        });
      },
      child: PageView.builder(
        itemCount: widget.imageURLs.length,
        itemBuilder: (_, index) {
          return CRPNetworkImage(imageURL: widget.imageURLs[index]);
        },
        reverse: true,
        controller: _controller,
      ),
    );
  }
}