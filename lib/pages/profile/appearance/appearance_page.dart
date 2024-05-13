import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/pages/profile/appearance/widget/change_language_tile.dart';

class AppearancePage extends StatefulWidget {
  const AppearancePage({super.key});

  @override
  State<AppearancePage> createState() => _AppearancePageState();
}

class _AppearancePageState extends State<AppearancePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("appearance".getString(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "applicationAppearance".getString(context).toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, letterSpacing: 1),
                textScaler: const TextScaler.linear(0.9),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ChangeLanguageSwitchTile(),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
