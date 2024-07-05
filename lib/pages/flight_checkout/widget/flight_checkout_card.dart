import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl/intl.dart';
import 'package:travellingo/component/airplane_animation_component.dart';
import 'package:travellingo/component/dotted_divider_component.dart';
import 'package:travellingo/component/my_image_loader.dart';
import 'package:travellingo/models/flight.dart';
import 'package:travellingo/utils/flight_class_util.dart';

class FlightCheckoutCard extends StatelessWidget {
  final Flight flight;
  const FlightCheckoutCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
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
        mainAxisAlignment:
            MainAxisAlignment.spaceEvenly, // Distribute the children evenly
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyImageLoader(
                url: flight.pictureLink,
                pictureType: flight.pictureType,
                height: 32,
                fit: BoxFit.cover,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${flight.flightNumber} • ${flight.airline}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    FlightClassUtil.stringFromClass(flight.flightClass)
                        .getString(context),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const DottedDivider(),
          const SizedBox(height: 8), // Add space between elements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                flight.departure,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                flight.arrival,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('HH:mm').format(flight.departureTime),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const AirplaneAnimation(),
              Text(
                DateFormat('HH:mm').format(flight.arrivalTime),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd MMM yyyy').format(flight.departureTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                '${flight.duration.inHours}h ${flight.duration.inMinutes.remainder(60)}m',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(flight.arrivalTime),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
