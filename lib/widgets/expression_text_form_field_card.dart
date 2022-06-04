import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpressionTextFormFieldCard extends StatelessWidget {
  ExpressionTextFormFieldCard({
    Key? key,
    this.hintText,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  final _inputFormatters = [
    FilteringTextInputFormatter.allow(RegExp(r'[\(\)\+\-\s1234567890x²³]')),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(16),
      child: TextFormField(
        focusNode: focusNode,
        controller: controller,
        textAlign: TextAlign.center,
        inputFormatters: _inputFormatters,
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.all(8),
        ),
      ),
    );
  }
}
