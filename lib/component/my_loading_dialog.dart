import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyLoadingDialog extends StatelessWidget {
  const MyLoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Lottie.asset("assets/lottie/travellingo_animation.json"),
    );
  }
}
