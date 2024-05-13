import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:travellingo/component/route_animator_component.dart';
import 'package:travellingo/pages/flight%20(done)/widget/button_choice.dart';
import 'package:travellingo/pages/flight%20(done)/widget/location_choice.dart';
import 'package:travellingo/pages/flight%20(done)/ticket_list/ticket_list_page.dart';

class FlightChoice extends StatefulWidget {
  const FlightChoice({super.key});

  @override
  State<FlightChoice> createState() => _FlightChoiceState();
}

class _FlightChoiceState extends State<FlightChoice> {
  ValueNotifier<String> from = ValueNotifier<String>("Kobe");
  ValueNotifier<String> to = ValueNotifier<String>("Himeji Castle");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int passengerCount = 1;
    String flightClass = "economy";
    return Container(
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
      constraints: const BoxConstraints(maxWidth: 350),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlightLocationChoice(from: from, to: to),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ButtonChoice(
                content: "Mon, 01 April",
                icon: Image.asset("assets/flight/calendar.png"),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonChoice(
                      content:
                          "${passengerCount.toString()} ${'passenger'.getString(context)}",
                      icon: Image.asset("assets/flight/passenger.png")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: ButtonChoice(
                      content: flightClass.getString(context),
                      icon: Image.asset("assets/flight/flight_class.png")),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 12),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFF5D161)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      createRouteFromBottom(TicketListPage(
                        from: from.value,
                        to: to.value,
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Text(
                    'search'.getString(context),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textScaler: const TextScaler.linear(1.2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
