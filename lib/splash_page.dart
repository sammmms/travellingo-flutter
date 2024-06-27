import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LottieBuilder.asset(
          'assets/lottie/travellingoAnimation.json',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
