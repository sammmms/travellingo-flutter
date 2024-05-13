import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/pages/profile/privacy_sharing/delete_account_page.dart';
import 'package:travellingo/pages/profile/privacy_sharing/request_personal_page.dart';
import 'package:travellingo/pages/profile/widget/privacy_button.dart';

Route _createRoute(StatefulWidget pages) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => pages,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class PrivacySharingPage extends StatelessWidget {
  const PrivacySharingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("privacyNSharing".getString(context)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "manageYourAccountData".getString(context),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                textScaler: const TextScaler.linear(1.5),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "manageYourAccountDataDetail".getString(context),
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(
                height: 20,
              ),
              PrivacyButton(
                  onClickFunction: () {
                    Navigator.of(context)
                        .push(_createRoute(const RequestPersonalPage()));
                  },
                  title: "requestYourPersonalData",
                  description: "requestYourPersonalDataDetail"),
              const SizedBox(
                height: 10,
              ),
              PrivacyButton(
                  onClickFunction: () {
                    Navigator.of(context)
                        .push(_createRoute(const DeleteAccountPage()));
                  },
                  title: "deleteYourAccount",
                  description: "deleteYourAccountDetail"),
            ],
          ),
        ));
  }
}
