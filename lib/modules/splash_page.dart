import 'package:flutter/material.dart';
import 'package:integral_e_do_mal/modules/main_page.dart';
import 'package:integral_e_do_mal/widgets/loading_widget.dart';

/// [Widget] da tela de splash.
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const route = '/';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      await Navigator.of(context).pushReplacementNamed(MainPage.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LoadingWidget());
  }
}
