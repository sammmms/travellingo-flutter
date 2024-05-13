import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:lottie/lottie.dart';
import 'package:travellingo/pages/main_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text(
          'transactionDetails'.getString(context),
          style: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: Color(0xFF292F2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                        width: 1.0), // Garis outline
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Lottie.asset(
                          "assets/lottie/success.json", // Use a static image instead of Lottie animation
                          fit: BoxFit.contain,
                        ),
                      ), // Size adjusted for visibility
                      const SizedBox(height: 16),
                      Text(
                        "${'yourPaymentWasSuccessful'.getString(context)}!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Color(0xFF292F2E),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      const DottedDivider(),
                      const SizedBox(height: 48),
                      SizedBox(
                        height: 184,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailText('invoiceNumber'.getString(context),
                                      '8C8D89', 14),
                                  detailText('INV567489240UI', '141511', 16),
                                  detailText(
                                      'date'.getString(context), '8C8D89', 14),
                                  detailText('01 April 2024', '141511', 16),
                                  detailText('amountPaid'.getString(context),
                                      '8C8D89', 14),
                                  detailText('\$475.22', '141511', 16),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  detailText('paymentMethod'.getString(context),
                                      '8C8D89', 14),
                                  detailText('e-Money', '141511', 16),
                                  detailText(
                                      'time'.getString(context), '8C8D89', 14),
                                  detailText('09:41 AM', '141511', 16),
                                  detailText('status'.getString(context),
                                      '8C8D89', 14),
                                  detailText('sucessful'.getString(context),
                                      '141511', 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const DottedDivider(),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.grey.withOpacity(0.1))),
                        onPressed: () {},
                        icon: const Icon(Icons.file_download_outlined,
                            color: Color(0xFF1C6AE4)),
                        label: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Download Invoice',
                            style: GoogleFonts.dmSans(
                              textStyle: const TextStyle(
                                color: Color(0xFF1C6AE4),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height:
                              24), // Spacing before the 'Return to Homepage' button
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MainPage()),
                    (route) => false,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'Return to Homepage',
                    style: GoogleFonts.dmSans(
                      textStyle: const TextStyle(
                        color:
                            Colors.white, // Choose appropriate color for text
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget detailText(String text, String color, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          textStyle: TextStyle(
            color: Color(int.parse('0xFF$color')),
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
