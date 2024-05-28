import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class MyTitle extends StatelessWidget {
  final String title;
  const MyTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(
        title.getString(context).toUpperCase(),
        style: Theme.of(context).textTheme.titleSmall,
        textScaler: const TextScaler.linear(0.9),
      ),
    );
  }
}
