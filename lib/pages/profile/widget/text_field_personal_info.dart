import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TextFieldPersonalInfo extends StatelessWidget {
  final TextEditingController controller;
  final bool isEnabled;
  final String content;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  const TextFieldPersonalInfo(
      {super.key,
      required this.content,
      required this.controller,
      required this.isEnabled,
      this.inputFormatters,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      inputFormatters: inputFormatters,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          enabled: isEnabled,
          filled: false,
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF6F8FB), width: 2),
              borderRadius: BorderRadius.circular(20)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 2),
              borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF6F8FB), width: 2),
              borderRadius: BorderRadius.circular(20)),
          disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFF6F8FB), width: 2),
              borderRadius: BorderRadius.circular(20)),
          labelText: content.getString(context).toUpperCase()),
    );
  }
}
