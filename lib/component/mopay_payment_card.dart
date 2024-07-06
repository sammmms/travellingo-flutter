import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';

class MopayPaymentCard extends StatelessWidget {
  final TextEditingController controller;
  const MopayPaymentCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "paymentWith".getString(context),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Image.asset(
                  "assets/images/mopay_logo.png",
                  width: 100,
                  fit: BoxFit.cover,
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "collabMopayDetail".getString(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: controller,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                String string = value ?? "";

                if (string.isEmpty) {
                  return "pleaseEnterYourPhoneNumber".getString(context);
                }

                if (string.length < 10) {
                  return "phoneNumberFormatIsWrong".getString(context);
                }

                return null;
              },
              keyboardType: TextInputType.phone,
              style: Theme.of(context).textTheme.displayLarge,
              decoration: InputDecoration(
                  hintText: "pleaseEnterYourPhoneNumber".getString(context),
                  prefixText: "+62 "),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
