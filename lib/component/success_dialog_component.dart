import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

showSuccessDialog(BuildContext context, String text, {Function? onClose}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          text,
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 90,
          height: 90,
          child: Lottie.asset(
            "assets/lottie/success.json", // Use a static image instead of Lottie animation
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          TextButton(
            onPressed: onClose != null
                ? () {
                    Navigator.of(context).pop();
                    onClose();
                  }
                : () {
                    Navigator.of(context).pop();
                  },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}
