import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottie/lottie.dart';

class NoFeaturePage extends StatelessWidget {
  const NoFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
            body: Center(
          child: Column(
            children: [
              Lottie.asset('assets/lottie/warning_animation.json', width: 200),
              const SizedBox(height: 16),
              Text("noFeatureYet".getString(context),
                  style: const TextStyle(fontSize: 16))
            ],
          ),
        )),
      ),
    );
  }
}
