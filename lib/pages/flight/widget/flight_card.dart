import 'package:flutter/material.dart';

class FlightCard extends StatelessWidget {
  // final Flight flight;
  const FlightCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(left: 18, right: 8),
      child: Card(
        surfaceTintColor: Colors.transparent,
        borderOnForeground: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(color: Colors.grey.shade300)),
        color: Theme.of(context).colorScheme.surfaceBright,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Kobe", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(width: 8),
                  const Text("Arima Onsen", style: TextStyle(fontSize: 14)),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text("24 Feb 2023 • 1 passenger • Economy",
                  style: TextStyle(color: Color(0xFF8C8D89), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
