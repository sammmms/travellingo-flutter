import 'package:flutter/material.dart';

void handlePushRoute(BuildContext context, Widget toRoute) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => toRoute));
}

void handlePushRemove(BuildContext context, Widget toRoute) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => toRoute), (route) => false);
}

void handlePushReplace(BuildContext context, Widget toRoute) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => toRoute));
}
