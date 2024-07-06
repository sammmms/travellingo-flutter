import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PrivacyButton extends StatelessWidget {
  final String title;
  final String description;
  final Function onClickFunction;
  const PrivacyButton(
      {super.key,
      required this.title,
      required this.description,
      required this.onClickFunction});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () => onClickFunction(),
        style: ButtonStyle(
            padding: const WidgetStatePropertyAll(EdgeInsets.all(15)),
            backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).colorScheme.surfaceBright),
            side: WidgetStatePropertyAll(
                BorderSide(color: Colors.grey.shade300, width: 1)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)))),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.getString(context),
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(description.getString(context),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            )))
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Color(0xFFF5D161))
            ],
          ),
        ));
  }
}
