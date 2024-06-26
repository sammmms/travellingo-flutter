import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

enum SnackbarStatus { failed, nothing, success, warning }

void showMySnackBar(BuildContext context, String text,
    [SnackbarStatus? status]) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: _getSnackBarColor(status ?? SnackbarStatus.nothing),
        duration: const Duration(milliseconds: 500),
        content: Text(
          text.getString(context),
          style: Theme.of(context).textTheme.labelLarge,
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
