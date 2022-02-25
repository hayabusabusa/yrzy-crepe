import 'package:flutter/material.dart';

import 'package:crepe_ui/crepe_ui.dart';

import 'package:crepe/app_router.dart';

class App extends StatelessWidget {
  const App({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: CRPTheme.light,
      darkTheme: CRPTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.home,
      onGenerateRoute: (settings) => AppRouter.generateRoute(settings),
    );
  }
}