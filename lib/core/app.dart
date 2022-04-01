import 'package:flutter/material.dart';
import 'package:integral_e_do_mal/modules/main_page.dart';
import 'package:integral_e_do_mal/modules/splash_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Integral é do mal',
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
