import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class MyErrorComponent extends StatelessWidget {
  final Function() onRefresh;
  const MyErrorComponent({super.key, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRefresh,
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("somethingWrong".getString(context)),
              IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh))
            ],
          ),
        ],
      ),
    );
  }
}
