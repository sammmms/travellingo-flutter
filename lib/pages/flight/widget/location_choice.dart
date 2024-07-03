import 'package:flutter/material.dart';
import 'package:travellingo/utils/dummy_data.dart';

class FlightLocationChoice extends StatelessWidget {
  final String from;
  final String to;
  final Function(String? departureCity) onChangedDeparture;
  final Function(String? arrivalCity) onChangedArrival;

  const FlightLocationChoice(
      {super.key,
      required this.from,
      required this.to,
      required this.onChangedDeparture,
      required this.onChangedArrival});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset("assets/flight/plane_boarding.png"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: from,
                        menuMaxHeight: 400,
                        borderRadius: BorderRadius.circular(12),
                        onChanged: onChangedDeparture,
                        items: indonesiaAirport
                            .map((e) => DropdownMenuItem(
                                value: e["kodeBandara"],
                                child:
                                    Text("${e["kota"]} (${e["kodeBandara"]})")))
                            .toList(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Image.asset("assets/flight/plane_landing.png"),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        menuMaxHeight: 400,
                        borderRadius: BorderRadius.circular(12),
                        value: to,
                        onChanged: onChangedArrival,
                        items: indonesiaAirport
                            .map((e) => DropdownMenuItem(
                                value: e["kodeBandara"],
                                child:
                                    Text("${e["kota"]} (${e["kodeBandara"]})")))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF28527A)),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(360),
                ))),
            icon: const Icon(Icons.swap_vert, color: Colors.white),
            onPressed: () {
              onChangedArrival(from);
            },
          )
        ],
      ),
    );
  }
}
