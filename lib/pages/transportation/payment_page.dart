import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:travellingo/component/route_animator_component.dart';
import 'package:travellingo/utils/dummy_data.dart';
import 'payment_success_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<bool> isChecked = List<bool>.filled(4, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment',
          style: GoogleFonts.dmSans(
            textStyle: const TextStyle(
              color: Color(0xFF292F2E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ... Progress bar code from previous snippets
                  const SizedBox(
                      height: 12), // Adds space below the progress bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24).copyWith(
                        bottom: 24), // Horizontal and bottom margin of 24
                    padding: const EdgeInsets.all(
                        16), // Padding inside the container
                    color: const Color(
                        0xFFFDE6EB), // Change this to your desired danger color
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.access_time,
                            color: Color(0xFFEE3D60)), // Icon with danger color
                        SizedBox(width: 8), // Spacing between icon and text
                        Text(
                          "The remaining time of order 00:05:49", // Your alert message
                          style: TextStyle(
                            color: Color(0xFFEE3D60), // Text color for danger
                            fontSize: 14, // Adjust the font size as needed
                            fontWeight: FontWeight
                                .bold, // Bold font weight for alert message
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: Text(
                      'Your Trip',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    height: 194, // Set the card height
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // Distribute the children evenly
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 32,
                              width: 52,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://i.pinimg.com/originals/2f/88/4b/2f884b66c1a53b93a9e4826e5f4c459d.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              'View Details',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF3E84A8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const DottedDivider(),
                        const SizedBox(height: 8), // Add space between elements
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kobe',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8C8D89),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Himeji Castle',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8C8D89),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '19.00 PM',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF141511),
                                fontSize: 16,
                              ),
                            ),
                            const Row(
                              mainAxisSize: MainAxisSize
                                  .min, // Use the minimum amount of space
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Color(0xFF3E84A8),
                                  size: 8,
                                ),
                                SizedBox(width: 8), // Add space between icons
                                AirplaneAnimation(),
                                SizedBox(width: 8), // Add space between icons
                                Icon(
                                  Icons.lens,
                                  color: Color(0xFF3E84A8),
                                  size: 8,
                                ),
                              ],
                            ),
                            Text(
                              '19.10 PM',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF141511),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '01 April 2024',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8C8D89),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'Duration 10m',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8C8D89),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '01 April 2024',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF8C8D89),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(
                        left: 24, right: 24, top: 32, bottom: 0),
                    child: Text(
                      'Payment Methods',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3),
                          width: 1.0), // Garis outline
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          12), // Set the padding inside the card
                      child: ListView(
                        shrinkWrap:
                            true, // Use only as much space as needed for the children
                        physics:
                            const NeverScrollableScrollPhysics(), // to disable ListView's scrolling
                        children: [
                          ListTile(
                            leading: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Color(0xFF3E84A8)),
                            title: Text('Paylater',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF141511))),
                            trailing: Text('Activate Now',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF3E84A8))),
                          ),
                          ExpansionTile(
                            shape: const Border(),
                            initiallyExpanded: true,
                            leading: const Icon(Icons.money,
                                color: Color(0xFF3E84A8)),
                            title: Text('e-Money',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF141511))),
                            children: List.generate(eMoneyPaymentMethods.length,
                                (index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.only(
                                    left: 36), // Indent the submenu items
                                leading: const Icon(Icons.circle,
                                    color: Color(0xFF3E84A8),
                                    size: 20), // Submenu icon
                                title: Text(eMoneyPaymentMethods[index],
                                    style: GoogleFonts.inter(
                                        color: const Color(0xFF141511))),
                                trailing: Checkbox(
                                  value: isChecked[index],
                                  side: MaterialStateBorderSide.resolveWith(
                                    (states) => BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.7)),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked[index] = value!;
                                    });
                                  },
                                  activeColor: Colors.orange,
                                ),
                              );
                            }),
                          ),
                          ExpansionTile(
                            shape: const Border(),
                            leading: const Icon(Icons.phone_android,
                                color: Color(0xFF3E84A8)),
                            title: Text('Virtual Account',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF141511))),
                            // Add children for the dropdown content
                          ),
                          ExpansionTile(
                            shape: const Border(),
                            leading: const Icon(Icons.account_balance,
                                color: Color(0xFF3E84A8)),
                            title: Text('Bank Transfer',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF141511))),
                            // Add children for the dropdown content
                          ),
                          ExpansionTile(
                            shape: const Border(),
                            leading: const Icon(Icons.credit_card,
                                color: Color(0xFF3E84A8)),
                            title: Text('Credit Card',
                                style: GoogleFonts.inter(
                                    color: const Color(0xFF141511))),
                            // Add children for the dropdown content
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subtotal',
                      style: GoogleFonts.dmSans(
                        color: const Color(0xFF6B7B78),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      '\$475.22',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF292F2E),
                        fontSize: 20,
                        fontWeight: FontWeight
                            .w600, // Inter doesn't have a 'semi-bold', w600 is 'semi-bold' equivalent
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF5D161)), // Button background color
                    foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFFFFFF)), // Text color
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                        const Size(95, 48)), // Set the button's size
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        createRouteFromBottom(const PaymentSuccessPage()));
                  },
                  child: Text(
                    'Pay Now',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
