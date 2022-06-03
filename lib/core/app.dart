import 'package:flutter/material.dart';
import 'package:integral_e_do_mal/modules/main_page.dart';
import 'package:integral_e_do_mal/modules/splash_page.dart';

// TODO: app icon
// TODO: provider
// TODO: l10n
// TODO: flutter web
// TODO: host

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(24)),
    );

    return MaterialApp(
      color: Colors.red,
      title: 'Integral é do mal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.red,
        textButtonTheme: TextButtonThemeData(style: buttonStyle),
        elevatedButtonTheme: ElevatedButtonThemeData(style: buttonStyle),
      ),
      routes: {
        SplashPage.route: (context) => const SplashPage(),
        MainPage.route: (context) => const MainPage(),
      },
    );
  }
}
