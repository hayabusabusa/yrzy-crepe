import 'package:flutter/material.dart';

/// アプリ独自のテーマクラス.
class CRPTheme {
  /// ライトモードのメインカラー.
  static const _lightModePrimaryColor = Color.fromRGBO(73, 187, 137, 1.0);
  /// ダークモードのメインカラー.
  static const _darkModePrimaryColor = Color.fromRGBO(86, 197, 150, 1.0);

  CRPTheme._();

  /// アプリのライトモードのテーマ
  static final light = ThemeData.light().copyWith(
    // メインカラー
    primaryColor: _lightModePrimaryColor,
    // divider のカラー
    dividerColor: const Color.fromRGBO(237, 237, 237, 1.0),
    // Scaffold の背景色
    scaffoldBackgroundColor: Colors.white,
    // トグル系のカラー
    toggleableActiveColor: _lightModePrimaryColor,
    // AppBar のテーマ
    appBarTheme: AppBarTheme(
      // AppBar の背景色
      color: Colors.white,
      shadowColor: Colors.black38,
      // AppBar のタイトルのフォント設定
      titleTextStyle: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      // AppBar のアイコンの色
      iconTheme: IconThemeData(
        color: Colors.grey.shade600,
      ),
      // AppBar のアクションに設定したアイコンの色
      actionsIconTheme: IconThemeData(
        color: Colors.grey.shade600,
      ),
    ),
    // テキストボタンのテーマ
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: _lightModePrimaryColor),
    )
  );

  /// アプリのダークモードのテーマ
  static final dark = ThemeData.dark().copyWith(
    // メインカラー
    primaryColor: _darkModePrimaryColor,
    // divider のカラー
    dividerColor: const Color.fromRGBO(84, 84, 88, 1.0),
    // トグル系のカラー
    toggleableActiveColor: _darkModePrimaryColor,
    // AppBar のテーマ
    appBarTheme: const AppBarTheme(
      // AppBar の背景色
      color: Color.fromRGBO(48, 48, 48, 1.0),
      // AppBar のタイトルのフォント設定
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
    ),
    // テキストボタンのテーマ
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: _darkModePrimaryColor),
    )
  );
}