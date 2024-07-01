import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PasswordTextField extends StatefulWidget {
  final bool enabled;
  final TextEditingController controller;
  const PasswordTextField(
      {super.key, required this.enabled, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.enabled,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "fieldmustbefilled".getString(context);
          }
          if (value.length < 8) {
            return "passwordformatwrong".getString(context);
          }
          return null;
        },
        controller: widget.controller,
        decoration: InputDecoration(
            filled: true,
            suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    isObscured = !isObscured;
                  });
                },
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: isObscured
                      ? const Icon(Icons.visibility, color: Color(0xFFF5D161))
                      : const Icon(Icons.visibility_off,
                          color: Color(0xFFF5D161)),
                ))),
        obscureText: isObscured,
        style: const TextStyle(letterSpacing: 1.1));
  }
}
