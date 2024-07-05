import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
            if (title != null) ...[
              Text(
                title!.getString(context),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(
                height: 10,
              )
            ],
            Text(
              label.getString(context),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (subLabel != null) ...[
              const SizedBox(
                height: 20,
              ),
              Text(subLabel!.getString(context))
            ],
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed:
                        onClickNegative ?? () => Navigator.pop(context, true),
                    child: Text(
                      (negativeLabel ?? "cancel").getString(context),
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    )),
                const SizedBox(
                  width: 20,
                ),
                OutlinedButton(
                  onPressed:
                      onClickPositive ?? () => Navigator.pop(context, false),
                  child: Text(
                    (positiveLabel ?? "yes").getString(context),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
