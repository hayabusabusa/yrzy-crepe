import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';

import 'package:crepe/screens/screens.dart';

class AppRouter {
  static const String home = "/";
  static const String favorites = "/favorites";
  static const String viewer = "/viewer";
  static const String bookDetail = "/book_detail";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const BooksScreen(),
        );
      case favorites:
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
        );
      case viewer:
        final args = settings.arguments as ViewerScreenArgs;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ViewerScreen(book: args.book),
        );
      case bookDetail:
        final args = settings.arguments as BookDetailScreenArgs;
        return MaterialPageRoute(
          builder: (_) => BookDetailScreen(book: args.book,),
        );
      default:
        throw UnimplementedError('/${settings.name} is not configured');
    }
  }
}

class ViewerScreenArgs {
  final Book book;

  ViewerScreenArgs({
    required this.book,
  });
}

class BookDetailScreenArgs {
  final Book book;

  BookDetailScreenArgs({
    required this.book,
  });
}