import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travellingo/component/airplane_animation_component.dart';

class BasketCard extends StatefulWidget {
  final Map<String, dynamic> basketData;

  const BasketCard({super.key, required this.basketData});

  @override
  State<BasketCard> createState() => _BasketCardState();
}

class _BasketCardState extends State<BasketCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.only(left: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with castle name and price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.basketData['castleName'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${widget.basketData['price'].toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${widget.basketData['ticketsLeft']} tickets remaining",
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Departure, arrival, and departure time
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.basketData['departure'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.basketData['departureTime'] ?? 'Unknown'}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Icon(Icons.circle, color: Color(0xFF3E84A8), size: 8),
                const SizedBox(width: 8),
                const AirplaneAnimation(),
                const SizedBox(width: 8),
                const Icon(Icons.circle, color: Color(0xFF3E84A8), size: 8),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.basketData['arrival'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.basketData['arrivalTime'] ?? 'Unknown'}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            // Flight icon, duration, and passenger count
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF28527A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Transform.rotate(
                        angle: pi / 4,
                        child: const Icon(Icons.airplanemode_active,
                            color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${widget.basketData['transport'] ?? 'Unknown'}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Duration ${widget.basketData['duration']}",
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF88879C)),
                ),
                const Spacer(),
                const Icon(Icons.person, color: Color(0xFF8AC4D0)),
                const SizedBox(width: 4),
                Text(
                  "Passenger ${widget.basketData['passengerCount']}",
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF8AC4D0)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
