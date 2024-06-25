import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/bloc/preferences/save_preferences.dart';
import 'package:travellingo/component/my_title.dart';
import 'package:travellingo/utils/theme_data/color_scheme.dart';

class UserNotificationPreference {
  bool email;
  bool pushNotification;

  UserNotificationPreference(
      {this.email = false, this.pushNotification = false});

  factory UserNotificationPreference.fromJson(Map<String, dynamic> json) {
    return UserNotificationPreference(
      email: json['email'],
      pushNotification: json['pushNotification'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'pushNotification': pushNotification,
    };
  }
}

class NotificationPage extends StatefulWidget {
  final UserNotificationPreference specialTipsAndOffers;
  final UserNotificationPreference activity;
  final UserNotificationPreference reminders;
  const NotificationPage(
      {super.key,
      required this.specialTipsAndOffers,
      required this.activity,
      required this.reminders});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late UserNotificationPreference specialTipsAndOffers;
  late UserNotificationPreference activity;
  late UserNotificationPreference reminders;

  @override
  void initState() {
    specialTipsAndOffers = widget.specialTipsAndOffers;
    activity = widget.activity;
    reminders = widget.reminders;
    super.initState();
  }

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
              ..._buildNotificationTile(specialTipsAndOffers),
              const MyTitle(title: "activity"),
              ..._buildNotificationTile(activity),
              const MyTitle(title: "reminders"),
              ..._buildNotificationTile(reminders),
            ],
          ),
        ));
  }

  List<Widget> _buildNotificationTile(UserNotificationPreference notification) {
    return [
      SwitchListTile(
        title: Text("pushNotification".getString(context)),
        inactiveTrackColor: colorScheme.onBackground,
        trackOutlineColor: const MaterialStatePropertyAll(Colors.transparent),
        value: notification.pushNotification,
        onChanged: (_) async {
          notification.pushNotification = !notification.pushNotification;
          await Store.saveNotificationPreferences(
              specialTipsAndOffers: specialTipsAndOffers,
              activity: activity,
              reminders: reminders);
          setState(() {});
        },
      ),
      SwitchListTile(
        title: Text("email".getString(context)),
        value: notification.email,
        inactiveTrackColor: colorScheme.onBackground,
        trackOutlineColor: const MaterialStatePropertyAll(Colors.transparent),
        onChanged: (_) async {
          notification.email = !notification.email;
          await Store.saveNotificationPreferences(
              specialTipsAndOffers: specialTipsAndOffers,
              activity: activity,
              reminders: reminders);
          setState(() {});
        },
      ),
    ];
  }
}
