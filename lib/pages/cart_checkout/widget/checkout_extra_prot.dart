import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class CheckoutExtraProtectionCard extends StatelessWidget {
  const CheckoutExtraProtectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.grey.withOpacity(0.3), width: 1.0), // Garis outline
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: 145, // Fixed height for the card
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment
                .start, // Aligns children at the start of the row's cross axis
            children: <Widget>[
              const Icon(
                Icons.verified_user, // Replace with your actual protection icon
                color: Color(0xFFFF7A1A),
                size: 24,
              ),
              const SizedBox(width: 12), // Spacing between icon and title
              Expanded(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Align the column content to the top
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'refundProtection'.getString(context),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      'refundProtectionDetail'.getString(context),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.withOpacity(
                            0.85), // Set text color for description
                      ),
                    ), // Spacing between the description and
                    const SizedBox(height: 8), // the 'More Info' text
                    RichText(
                      text: TextSpan(
                        text: 'moreInfo'.getString(context),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                        recognizer: TapGestureRecognizer()..onTap = () => {},
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
