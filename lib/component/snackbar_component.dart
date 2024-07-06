import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

enum SnackbarStatus { failed, nothing, success, warning }

void showMySnackBar(BuildContext context, String text,
    [SnackbarStatus status = SnackbarStatus.nothing, bool isLong = false]) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: _getSnackBarColor(status),
        duration: Duration(milliseconds: isLong ? 500 : 2000),
        content: Text(
          text.getString(context),
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Theme.of(context).colorScheme.onPrimary),
        )));
  });
}

Color _getSnackBarColor(SnackbarStatus status) {
  switch (status) {
    case SnackbarStatus.failed:
      return Colors.redAccent;
    case SnackbarStatus.success:
      return colorScheme.primary;
    case SnackbarStatus.warning:
      return Colors.orangeAccent;
    default:
      return colorScheme.primary;
  }
}
