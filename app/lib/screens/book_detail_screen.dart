import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:crepe_core/crepe_core.dart';
import 'package:crepe_ui/crepe_ui.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({ 
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("本詳細"),
      ),
      body: _Body(book: book,),
    );
  }
}

// MARK: - Body

class _Body extends StatelessWidget {
  final Book book;

  const _Body({ 
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Thumbnail(thumbnailURL: book.thumbnailURL),
            const SizedBox(height: 12.0,),
            _Titles(title: book.title, author: book.author,),
            _Label(
              title: "ページ数: ", 
              content: "${book.imageURLs.length}ページ",
            ),
            _Label(
              title: "追加日時: ", 
              content: "${book.createdAt.year}-${book.createdAt.month}-${book.createdAt.day}",
            ),
            const _Divider(),
            _Categories(categories: book.categories),
            const _Divider(),
            _Link(url: book.url),
            const SizedBox(height: 24,),
          ],
        ),
      ),
    );
  }
}

// MARK: - Thumbnail

class _Thumbnail extends StatelessWidget {
  final String? thumbnailURL;

  const _Thumbnail({ 
    Key? key,
    required this.thumbnailURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return thumbnailURL == null 
      ? const SizedBox()
      : CRPNetworkImage(
          height: 200,
          fit: BoxFit.cover,
          imageURL: thumbnailURL ?? "",
        );
  }
}

// MARK: - Titles

class _Titles extends StatelessWidget {
  final String title;
  final String? author;

  const _Titles({ 
    Key? key,
    required this.title,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.merge(
              const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: author == null 
              ? null 
              : () {

              }, 
            child: Text(
              author ?? "作者不明",
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Label

class _Label extends StatelessWidget {
  final String title;
  final String? content;

  const _Label({ 
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return content == null 
      ? const SizedBox() 
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
                Expanded(
                  child: Text(
                    content ?? "",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
        );
  }
}

// MARK: - Categories

class _Categories extends StatelessWidget {
  final List<String> categories;
  
  const _Categories({ 
    Key? key,
    required this.categories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Wrap(
        spacing: 4.0,
        runSpacing: -8.0,
        children: categories
          .map((category) { 
            return Chip(
              label: Text(
                category,
                style: Theme.of(context).textTheme.caption,
              ),
            );
          })
          .toList(),
      ),
    );
  }
}

// MARK: - Link

class _Link extends StatelessWidget {
  final String? url;

  const _Link({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return url == null 
      ? const SizedBox() 
      : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: TextButton(
            onPressed: () async {
              // URL をクリップボードにコピー
              final data = ClipboardData(text: url ?? "");
              await Clipboard.setData(data);

              // SnackBar で通知
              const snackBar = SnackBar(
                content: Text("クリップボードにコピーしました"),
                duration: Duration(seconds: 3),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, 
            child: Text(
              url ?? "",
              style: const TextStyle(fontSize: 11.0),
            ),
          ),
        );
  }
}

// MARK: - Divider

class _Divider extends StatelessWidget {
  const _Divider({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        height: 1.0,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}