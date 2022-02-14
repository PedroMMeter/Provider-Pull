import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Field extends StatelessWidget {
  final String labelContent;
  final int charAmount;
  final TextInputType? type;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validation;
  final TextEditingController controller;

  const Field(this.labelContent, this.charAmount,
      {Key? key, this.type, this.formatters, required this.validation, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelContent,
        ),
        maxLength: charAmount,
        keyboardType: type,
        inputFormatters: formatters,
        validator: validation,
        controller: controller,
      ),
    );
  }
}
