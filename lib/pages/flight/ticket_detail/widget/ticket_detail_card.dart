import 'dart:math';

import 'package:flutter/material.dart';
import 'package:travellingo/component/airplane_animation_component.dart';

class TicketDetailCard extends StatelessWidget {
  final Map<String, dynamic> ticketData;
  const TicketDetailCard({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   ticketData['destination'] ?? 'Unknown Castle',
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //     color: Colors.black,
                //   ),
                // ),
                Image.network(
                  ticketData["image"],
                  width: 50,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${(ticketData['price'] ?? 0).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${ticketData['available'] ?? '0'} tickets remaining",
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
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticketData['origin'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${ticketData['departureTime'] ?? 'Unknown'}",
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
                      ticketData['destination'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${ticketData['arrivalTime'] ?? 'Unknown'}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                        "${ticketData['transport'] ?? 'Unknown'}",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Duration ${ticketData['duration'] ?? 'Unknown'}",
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xFF88879C)),
                ),
                const Spacer(),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5D161),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        size: 16, color: Colors.white),
                    onPressed: () {
                      // Handle tap here
                    },
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
