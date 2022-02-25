import 'package:flutter/material.dart';

import 'package:crepe_core/crepe_core.dart';

import 'package:crepe/screens/screens.dart';

class AppRouter {
  static const String home = "/";
  static const String viewer = "/viewer";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const BooksScreen(),
        );
      case viewer:
        final args = settings.arguments as ViewerScreenArgs;
        return MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ViewerScreen(book: args.book),
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