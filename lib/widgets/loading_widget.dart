import 'package:flutter/material.dart';

/// [Widget] do ícone de carregamento.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Center(
        child: SizedBox.square(
          dimension: 32,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
