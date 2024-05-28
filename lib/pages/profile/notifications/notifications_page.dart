import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/my_title.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("notification".getString(context)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyTitle(title: "specialTipsAndOffers"),
              ..._buildNotificationTile(),
              const MyTitle(title: "activity"),
              ..._buildNotificationTile(),
              const MyTitle(title: "reminders"),
              ..._buildNotificationTile(),
            ],
          ),
        ));
  }

  List<Widget> _buildNotificationTile() {
    return [
      SwitchListTile(
        title: Text("pushNotification".getString(context)),
        value: true,
        onChanged: (_) {},
      ),
      SwitchListTile(
        title: Text("email".getString(context)),
        value: true,
        onChanged: (_) {},
      ),
    ];
  }
}
