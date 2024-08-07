import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/transition_animation.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/models/passenger.dart';
import 'package:travellingo/pages/flight/select_seat/select_seat_page.dart';
import 'package:travellingo/pages/flight_checkout/flight_payment_page.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_card.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_passenger.dart';
import 'package:travellingo/pages/flight_checkout/widget/flight_checkout_protection.dart';
import 'package:travellingo/utils/format_currency.dart';

class FlightCheckoutPage extends StatefulWidget {
  final Flight flight;
  final List<Passenger> passengers;
  const FlightCheckoutPage({
    super.key,
    required this.flight,
    required this.passengers,
  });

  @override
  State<FlightCheckoutPage> createState() => _FlightCheckoutPageState();
}

class _FlightCheckoutPageState extends State<FlightCheckoutPage> {
  bool isChecked = false;
  late int totalProtection;

  @override
  void initState() {
    totalProtection =
        (widget.flight.price * widget.passengers.length * 0.25).toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        child: Scaffold(
          appBar: AppBar(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        height: 20,
                      ),
                      FlightCheckoutCard(
                        flight: widget.flight,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'passengerList'.getString(context),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 16,
                              ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.passengers.length,
                          itemBuilder: (context, index) {
                            Flight flight = widget.flight;
                            Passenger passenger = widget.passengers[index];

                            return FlightCheckoutPassengerCard(
                                flight: flight,
                                passenger: passenger,
                                onClickChangeSeat: () async {
                                  await Navigator.push(
                                      context,
                                      slideInFromBottom(
                                        SelectSeatPage(
                                          passengers: widget.passengers,
                                          flight: flight,
                                          isChangingSeat: true,
                                        ),
                                      ));
                                  setState(() {});
                                });
                          }),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                visualDensity: VisualDensity.compact,
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
                              Text(
                                'protectYourTrip'.getString(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Text(
                            '${formatToIndonesiaCurrency(totalProtection)} / ${'person'.getString(context).toUpperCase()}',
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
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('subtotal'.getString(context),
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(width: 8), // Spacing between text
                  const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                  ), // Info icon
                ],
              ),
              Text(
                isChecked
                    ? formatToIndonesiaCurrency(
                        widget.flight.price * widget.passengers.length +
                            totalProtection)
                    : formatToIndonesiaCurrency(
                        widget.flight.price * widget.passengers.length),
                style: const TextStyle(
                  fontSize: 12,
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
              Navigator.push(
                  context,
                  slideInFromRight(FlightPaymentPage(
                    flight: widget.flight,
                    passengers: widget.passengers,
                    additionalPayment: isChecked ? totalProtection : 0,
                  )));
            },
            child: Text(
              'proceedToPayment'.getString(context),
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
