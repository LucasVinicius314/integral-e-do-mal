import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LimitTextFormField extends StatelessWidget {
  LimitTextFormField({
    Key? key,
    this.focusNode,
    this.labelText,
    this.controller,
  }) : super(key: key);

  final String? labelText;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  final _inputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
  ];

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      textAlign: TextAlign.end,
      inputFormatters: _inputFormatters,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        isDense: true,
        labelText: labelText,
        alignLabelWithHint: true,
        labelStyle: Theme.of(context).textTheme.caption,
      ),
    );
  }
}
