import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("notification".getString(context)),
      ),
    );
  }
}
