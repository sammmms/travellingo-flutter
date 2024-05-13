import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CircleCheckboxComponent extends StatelessWidget {
  final void Function() onClickFunction;
  const CircleCheckboxComponent({super.key, required this.onClickFunction});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        splashRadius: 10,
        value: context.watch<bool>(),
        shape: const CircleBorder(),
        checkColor: const Color.fromARGB(255, 245, 209, 97),
        fillColor: const MaterialStatePropertyAll(Colors.white),
        side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(
            width: 2.0, color: Color.fromARGB(255, 245, 209, 97))),
        onChanged: (value) {
          onClickFunction();
        },
      ),
    );
  }
}
