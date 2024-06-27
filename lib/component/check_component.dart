import 'package:flutter/material.dart';

class CircleCheckboxComponent extends StatelessWidget {
  final void Function() onClickFunction;
  final bool isChecked;
  const CircleCheckboxComponent(
      {super.key, required this.onClickFunction, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        splashRadius: 10,
        value: isChecked,
        shape: const CircleBorder(),
        checkColor: const Color.fromARGB(255, 245, 209, 97),
        fillColor: const WidgetStatePropertyAll(Colors.white),
        side: WidgetStateBorderSide.resolveWith((states) => const BorderSide(
            width: 2.0, color: Color.fromARGB(255, 245, 209, 97))),
        onChanged: (value) {
          onClickFunction();
        },
      ),
    );
  }
}
