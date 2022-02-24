import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:crepe/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: Firebase のセットアップ.
  await Firebase.initializeApp();

  runApp(const App());
}