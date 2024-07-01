import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:lottie/lottie.dart';

class MyNoDataComponent extends StatelessWidget {
  final String? label;
  final Function()? onRefresh;
  const MyNoDataComponent({super.key, this.label, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRefresh,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/empty_animation.json"),
            Text(label == null
                ? "noData".getString(context)
                : "noItemInCart".getString(context)),
            if (onRefresh != null) ...[
              const SizedBox(
                height: 20,
              ),
              Text("clickToRefresh".getString(context))
            ]
          ],
        ),
      ),
    );
  }
}
