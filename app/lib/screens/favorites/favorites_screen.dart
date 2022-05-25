import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}