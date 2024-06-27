import 'package:flutter/material.dart';
import 'package:travellingo/utils/theme_data/light_theme.dart';

class MyConfirmationDialog extends StatelessWidget {
  final String? title;
  final String label;
  final String? subLabel;
  final String? positiveLabel;
  final String? negativeLabel;
  final Function()? onClickPositive;
  final Function()? onClickNegative;
  const MyConfirmationDialog(
      {super.key,
      this.title,
      required this.label,
      this.subLabel,
      this.positiveLabel,
      this.negativeLabel,
      this.onClickPositive,
      this.onClickNegative});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Text(
                title!,
                style: textStyle.headlineLarge,
              ),
            Text(
              label,
              style: textStyle.headlineMedium,
            ),
            if (subLabel != null) Text(subLabel!),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                    onPressed:
                        onClickNegative ?? () => Navigator.pop(context, false),
                    child: Text(
                      negativeLabel ?? "Cancel",
                      style: textStyle.labelLarge,
                    )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed:
                        onClickPositive ?? () => Navigator.pop(context, true),
                    child: Text(
                      positiveLabel ?? "Yes",
                      style: textStyle.labelLarge,
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
