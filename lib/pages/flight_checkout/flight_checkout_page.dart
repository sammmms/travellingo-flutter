import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/models/cart.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_card.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_passenger.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_protection.dart';

class CheckoutPage extends StatefulWidget {
  final List<CartItems> cartItems;
  const CheckoutPage({super.key, required this.cartItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surfaceTint,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFF5D161)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'checkout'.getString(context),
        ),
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'yourTrip'.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) => FlightCheckoutCard(
                      items: widget.cartItems[index],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'passengerList'.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const FlightCheckoutPassengerCard(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked,
                            side: WidgetStateBorderSide.resolveWith(
                              (states) => BorderSide(
                                  width: 1.0,
                                  color: Colors.grey.withOpacity(0.7)),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (bool? value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Protect Your Trip',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$5 ${'perPerson'.getString(context).toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF3E84A8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const FlightExtraProtection(),
                ],
              ),
            ),
          ),
          _buildBottomAppBar()
        ],
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      color: Color(0xFF6B7B78),
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(width: 8), // Spacing between text
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ), // Info icon
                ],
              ),
              Text(
                '\$475.22',
                style: TextStyle(
                  color: Color(0xFF292F2E),
                  fontSize: 20,
                  fontWeight: FontWeight
                      .w600, // Inter doesn't have a 'semi-bold', w600 is 'semi-bold' equivalent
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFFF5D161)), // Button background color
              foregroundColor: WidgetStateProperty.all<Color>(
                  const Color(0xFFFFFFFF)), // Text color
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                  const Size(95, 48)), // Set the button's size
            ),
            onPressed: () {
              // Navigator.push(context, slideInFromRight(const PaymentPage()));
            },
            child: const Text(
              'Proceed to Payment',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
