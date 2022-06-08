import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// [TextFormField] envolvido por um [Card], utilizado para escrever expressões.
class ExpressionTextFormFieldCard extends StatelessWidget {
  ExpressionTextFormFieldCard({
    Key? key,
    this.hintText,
    this.focusNode,
    this.validator,
    this.controller,
  }) : super(key: key);

  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

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
        validator: validator,
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
