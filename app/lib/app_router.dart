import 'package:flutter/material.dart';

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
      default:
        throw UnimplementedError('/${settings.name} is not configured');
    }
  }
}